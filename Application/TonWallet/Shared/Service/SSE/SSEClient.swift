import BigInt
import TweetNacl
import Moya

class SSEClient: NSObject {
    
    static let shared = SSEClient()
    
    private var session: URLSession?
    private var task: URLSessionDataTask?
    private let userSettings: UserSettings = .shared
    
    private let bridgeUrl = "https://bridge.tonapi.io/bridge"
    
    func connectToSSE() {
        guard !userSettings.connections.isEmpty else { return }
        
        let walletSessionIds = userSettings.connections
            .map { SessionCrypto(keyPair: $0.sessionKeyPair).sessionId }
            .joined(separator: ",")
        
        var url = "\(bridgeUrl)/events?client_id=\(walletSessionIds)"
        
        let lastEventId = getLastEventId()

        if let lastEventId = lastEventId {
            url += "&last_event_id=\(lastEventId)"
        }
        
        print("💙 will start session with url: \(url)")
        
        let sessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        task = session?.dataTask(with: URL(string: url)!)
        task?.resume()
    }
    
    private func getLastEventId() -> String? {
        return userSettings.lastEventId?.description
    }
}

extension SSEClient: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard
            let string = String(data: data, encoding: .utf8),
            string != "\n",
            !string.contains("body: heartbeat")
        else { return }
           
        var dataString = string
        dataString.insert("{", at: dataString.startIndex)
        dataString.append("}")
        dataString = dataString.replacingOccurrences(of: "\n", with: "")
        dataString = dataString.replacingOccurrences(of: "id", with: "\"id\"")
        dataString = dataString.replacingOccurrences(of: "data", with: ",\"data\"")
                
        do {
            let newData = dataString.data(using: .utf8)!
            let messageData = try JSONDecoder().decode(MessageData.self, from: newData)
            
            let from = messageData.data.from
            let message = messageData.data.message
            
            if let connection = userSettings.connections.first(where: { $0.clientSessionId == from }) {
                userSettings.lastEventId = messageData.id
                
                let sessionCrypto = SessionCrypto(keyPair: connection.sessionKeyPair)
                let messageData = Data(base64Encoded: message)!
                let fromData = Data(hex: from)!
                let jsonData = try sessionCrypto.decrypt(message: messageData, senderPublicKey: fromData)
                let request = try JSONDecoder().decode(RpcRequests.self, from: jsonData)
                
                if request.method == "sendTransaction", let params = request.params.first {
                    let paramsData = params.data(using: .utf8)!
                    let params = try JSONDecoder().decode(SendTransactionParams.self, from: paramsData)
                    
                    #warning("need get address from connection????")
                    let address = try WalletManager.shared.currentWallet?.activeContract?.contract.address()
                    let target = WalletAPI.getSeqno(address: address?.toRaw().lowercased() ?? "")
                    
                    MoyaProvider().request(target) { result in
                        do {
                            let response = try result.get()
                            let seqno = try response.decode(Int.self, atKeyPath: "seqno")

                            
                            let sendMode = SendMode(rawValue: 3)!
                            var messages: [MessageRelaxed] = []
                            
                            for message in params.messages {
                                let address = try! Address.parse(message.address)
                                let payload = try Cell.fromBase64(src: message.payload!)
                                let amount = BigInt(message.amount)!
                                
                                let relaxed = MessageRelaxed.internal(to: address, value: BigUInt(amount), body: payload)
                                messages.append(relaxed)
                            }
                            
                            let transferData = WalletTransferData(
                                seqno: UInt64(seqno),
                                secretKey: nil,
                                messages: messages,
                                sendMode: sendMode,
                                timeout: nil
                            )

                            let wallet = WalletManager.shared.currentWallet!.activeContract?.contract as! WalletV4R2
                            let boc = try wallet.createExternalMessage(args: transferData).toBoc().base64EncodedString()
                            let target = WalletAPI.estimate(boc: boc)

                            MoyaProvider().request(target) { result in
                                do {
                                    let accountEvent = try result.get().decode(AccountEvent.self)
//                                    let decoder = JSONDecoder()
//                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//                                    let accountEvent = try decoder.decode(AccountEvent.self, from: response.data)
                                    
                                    print("💙 Emulation success - json: \(accountEvent)")
                                } catch {
                                    if let error  = error as? MoyaError {
                                        if let data = error.response?.data {
                                            let string = String(data: data, encoding: .utf8)!

                                            print("❤️ MoyaError - \(error.response!.statusCode) - \(string)")
                                        } else {
                                            print("❤️ Emulation unknown failure - error: \(error.localizedDescription)")
                                        }
                                    } else {
                                        print("❤️ decode error: \(error.localizedDescription)")
                                    }
                                }
                            }
                        } catch {
                            if let error = error as? MoyaError {
                                if let data = error.response?.data {
                                    let json = try! JSONSerialization.jsonObject(with: data)
                                    print("❤️ error description - \(json)")
                                } else {
                                    print("❤️ moya error - \(error.localizedDescription)")
                                }
                            } else {
                                print("❤️ error - \(error.localizedDescription)")
                            }
                        }
                    }
                }
            } else {
                print("❤️ Connection with clientId \(from) not found!")
            }
        } catch {
            print("❤️ error: \(error)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE connection error: \(error)")
            
            if (error as NSError).code == -1005 {
                connectToSSE()
            }
        }
    }
}

struct MessageData: Codable {
    let id: Int
    let data: MessageContent
}

struct MessageContent: Codable {
    let from: String
    let message: String
}

struct SignDataRequest: Codable {
    let id: String
    let method: String
    let params: [SignDataParams]
}

struct SignDataParams: Codable {
    let schema_crc: Int
    let cell: String
}

struct DisconnectRequest: Codable {
    let method: String
    let id: String
}

struct RpcRequests: Codable {
    let id: String
    let method: String
    let params: [String]
}


struct SendTransactionParams: Codable {
    let messages: [SendTransactionMessage]
    let validUntil: Int
    let from: String
    let network: String

    enum CodingKeys: String, CodingKey {
        case messages
        case validUntil = "valid_until"
        case from, network
    }
}



// MARK: - Message

struct SendTransactionMessage: Codable {
    let address: String
    
    /// (decimal string): number of nanocoins to send.
    let amount: String
    
    /// (string base64, optional): raw one-cell BoC encoded in Base64./
    let payload: String?
    
    /// (string base64, optional): raw once-cell BoC encoded in Base64.
    let stateInit: String?
}

let zero = BigInt(0)
let negative1 = BigInt(-1)

let unitMap: [String: String] = [
    "noether":    "0",
    "wei":        "1",
    "kwei":       "1000",
    "Kwei":       "1000",
    "babbage":    "1000",
    "femtoether": "1000",
    "mwei":       "1000000",
    "Mwei":       "1000000",
    "lovelace":   "1000000",
    "picoether":  "1000000",
    "gwei":       "1000000000",
    "Gwei":       "1000000000",
    "shannon":    "1000000000",
    "nanoether":  "1000000000",
    "nano":       "1000000000",
    "szabo":      "1000000000000",
    "microether": "1000000000000",
    "micro":      "1000000000000",
    "finney":     "1000000000000000",
    "milliether": "1000000000000000",
    "milli":      "1000000000000000",
    "ether":      "1000000000000000000",
    "kether":     "1000000000000000000000",
    "grand":      "1000000000000000000000",
    "mether":     "1000000000000000000000000",
    "gether":     "1000000000000000000000000000",
    "tether":     "1000000000000000000000000000000"
]

func getValueOfUnit(_ unitInput: String) throws -> BigInt {
    let unit = unitInput.lowercased()
    
    guard let unitValue = unitMap[unit] else {
        throw NSError(domain: "ethjs-unit", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "The unit provided \(unitInput) doesn't exist. Please use one of the following units: \(unitMap)"
        ])
    }
    
    return BigInt(unitValue, radix: 10)!
}

func toWei(_ etherInput: Double, _ unit: String) throws -> BigInt {
    var ether = etherInput.description
    let base = try getValueOfUnit(unit)
    let baseLength = unitMap[unit]!.count - 1
    
    var negative = false
    if ether.first == "-" {
        ether.removeFirst()
        negative = true
    }
    
    if ether == "." {
        throw NSError(domain: "ethjs-unit", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "[ethjs-unit] While converting number \(etherInput) to wei, invalid value"
        ])
    }
    
    let comps = ether.split(separator: ".")
    if comps.count > 2 {
        throw NSError(domain: "ethjs-unit", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "[ethjs-unit] While converting number \(etherInput) to wei, too many decimal points"
        ])
    }
    
    let whole = comps.first ?? "0"
    var fraction = comps.count == 2 ? comps[1] : "0"
    
    if fraction.count > baseLength {
        throw NSError(domain: "ethjs-unit", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "[ethjs-unit] While converting number \(etherInput) to wei, too many decimal places"
        ])
    }
    
    while fraction.count < baseLength {
        fraction += "0"
    }
    
    let wholeBigInt = BigInt(whole)!
    let fractionBigInt = BigInt(fraction)!
    
    var wei = wholeBigInt * base + fractionBigInt
    
    if negative {
        wei *= negative1
    }
    
    return wei
}
