import Foundation
import TweetNacl
import Starscream

class SSEClient: NSObject {
    
    static let shared = SSEClient()
    
    private var session: URLSession?
    private var task: URLSessionDataTask?
    private var socket: WebSocket!
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
        let newData = dataString.data(using: .utf8)!
                
        do {
            let messageData = try JSONDecoder().decode(MessageData.self, from: newData)
            
            print("💙 messageData did decoded: \(messageData)")
            
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
                    
                    print("💙 params decoded: \(params)")
                }
            } else {
                print("❤️ Connection with clientId \(from) not found!")
            }
        } catch {
            print(error)
            print("❤️ failure decode message")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Обработка ошибок или завершения соединения
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
    let amount: String
    let payload: String
}
