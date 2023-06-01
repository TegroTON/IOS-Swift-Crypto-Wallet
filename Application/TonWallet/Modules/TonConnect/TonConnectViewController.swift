import UIKit
import Kingfisher
import CryptoKit
import Alamofire
import CommonCrypto
import TweetNacl

class TonConnectViewController: UIViewController {
    
    private var model: ConnectQuery
    private let tonManager: TonManager = .shared
    private let provider: TonConnectProvider = .init()
#warning("need to implement selectedWallet or somthing like that in WalletManager")
    private let wallet = WalletManager.shared.wallets.first!
    private var keyPair: TonKeyPair?
    private var manifest: DAppManifest! {
        didSet {
            updateContent()
        }
    }
    
    private var mainView: TonConnectView { view as! TonConnectView }
    override func loadView() { view = TonConnectView() }
    
    init(model: ConnectQuery) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        sessionId = generateSessionID()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sessionId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tonManager.delegate = self
        keyPair = KeychainManager().getKey(id: wallet.id)!
        
        provider.delegate = self
        provider.requestManifest(with: model.request.manifestUrl)
        
        mainView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private actions
    
    @objc private func connectButtonTapped() {
        tonManager.createStateInit(pbKey: keyPair!.publicKey)
    }
    
    // MARK: - Private methods
    
    private func createResponse(stateInit: String) {
        let replyItems: [ConnectItemReply] = createReplyItems(keyPair: keyPair!, stateInit: stateInit)
        let payload = Payload(items: replyItems, device: tonConnectDeviceInfo)
        let response = ConnectEvent(id: 0, event: "connect", payload: payload)
        
        send(response: response)
    }
    
    private func updateContent() {
        if let url = URL(string: manifest.iconUrl) {
            mainView.titleLabel.text = manifest.name
            mainView.iconImageView.kf.setImage(with: url)
        }
    }
    
    private func createReplyItems(keyPair: TonKeyPair, stateInit: String) -> [ConnectItemReply] {
        let address = tonManager.getAddress(.v4r2, publicKey: keyPair.publicKey, isUserFriendly: false).address.lowercased()
        var replyItems = [ConnectItemReply]()
        
        let mnem = KeychainManager().getMnemonics(id: self.wallet.id)!
        let keyP = try! Mnemonic.mnemonicToPrivateKey(mnemonicArray: mnem)
                
        let wallet = WalletV4R1(publicKey: keyP.publicKey)
        let codeBOC = try! wallet.stateInit.code!.toBoc()
        let base64BOC = bytesToBase64(codeBOC)
        let codeBOCFromTonkeeperLogs = "te6cckECFgEAAwQAAgE0ARUBFP8A9KQT9LzyyAsCAgEgAxACAUgEBwLm0AHQ0wMhcbCSXwTgItdJwSCSXwTgAtMfIYIQcGx1Z70ighBkc3RyvbCSXwXgA/pAMCD6RAHIygfL/8nQ7UTQgQFA1yH0BDBcgQEI9ApvoTGzkl8H4AXTP8glghBwbHVnupI4MOMNA4IQZHN0crqSXwbjDQUGAHgB+gD0BDD4J28iMFAKoSG+8uBQghBwbHVngx6xcIAYUATLBSbPFlj6Ahn0AMtpF8sfUmDLPyDJgED7AAYAilAEgQEI9Fkw7UTQgQFA1yDIAc8W9ADJ7VQBcrCOI4IQZHN0coMesXCAGFAFywVQA88WI/oCE8tqyx/LP8mAQPsAkl8D4gIBIAgPAgEgCQ4CAVgKCwA9sp37UTQgQFA1yH0BDACyMoHy//J0AGBAQj0Cm+hMYAIBIAwNABmtznaiaEAga5Drhf/AABmvHfaiaEAQa5DrhY/AABG4yX7UTQ1wsfgAWb0kK29qJoQICga5D6AhhHDUCAhHpJN9KZEM5pA+n/mDeBKAG3gQFImHFZ8xhAT48oMI1xgg0x/TH9MfAvgju/Jk7UTQ0x/TH9P/9ATRUUO68qFRUbryogX5AVQQZPkQ8qP4ACSkyMsfUkDLH1Iwy/9SEPQAye1U+A8B0wchwACfbFGTINdKltMH1AL7AOgw4CHAAeMAIcAC4wABwAORMOMNA6TIyx8Syx/L/xESExQAbtIH+gDU1CL5AAXIygcVy//J0Hd0gBjIywXLAiLPFlAF+gIUy2sSzMzJc/sAyEAUgQEI9FHypwIAcIEBCNcY+gDTP8hUIEeBAQj0UfKnghBub3RlcHSAGMjLBcsCUAbPFlAE+gIUy2oSyx/LP8lz+wACAGyBAQjXGPoA0z8wUiSBAQj0WfKnghBkc3RycHSAGMjLBcsCUAXPFlAD+gITy2rLHxLLP8lz+wAACvQAye1UAFEAAAAAKamjF2+3dx3OOyinuPG7FrSkVTfJK/huaa20k2GA++M/nHrNQKXDJSE="
        
        model.request.items.forEach { item in
            switch item.name {
            case "ton_addr":
                let addressItem = ConnectItemReply(
                    name: "ton_addr",
                    address: address,
                    network: .mainnet,
                    walletStateInit: base64BOC,
                    publicKey: tonManager.convertKeyToHex(keyPair.publicKey).lowercased()
                )
                replyItems.append(addressItem)
                
            case "ton_proof":
                let tonProofItem = createTonProofItem(address: address, keyPair: keyPair, payload: item.payload!)
                
                replyItems.append(tonProofItem)
                
            default: break
            }
        }
        
        return replyItems
    }
    
    func bytesToBase64(_ bytes: Data) -> String {
        var result = ""
        var i = 0
        let l = bytes.count
        
        for i in stride(from: 2, to: l, by: 3) {
            result += String(base64abc[Int(bytes[i - 2]) >> 2])
            result += String(base64abc[((Int(bytes[i - 2]) & 0x03) << 4) | (Int(bytes[i - 1]) >> 4)])
            result += String(base64abc[((Int(bytes[i - 1]) & 0x0f) << 2) | (Int(bytes[i]) >> 6)])
            result += String(base64abc[Int(bytes[i]) & 0x3f])
        }
        
        if i == l + 1 {
            // 1 octet missing
            result += String(base64abc[Int(bytes[i - 2]) >> 2])
            result += String(base64abc[(Int(bytes[i - 2]) & 0x03) << 4])
            result += "=="
        }
        
        if i == l {
            // 2 octets missing
            result += String(base64abc[Int(bytes[i - 2]) >> 2])
            result += String(base64abc[((Int(bytes[i - 2]) & 0x03) << 4) | (Int(bytes[i - 1]) >> 4)])
            result += String(base64abc[(Int(bytes[i - 1]) & 0x0f) << 2])
            result += "="
        }
        
        return result
    }

    
    let base64abc: [Character] = {
        var abc = [Character]()
        let A = Character("A").asciiValue!
        let a = Character("a").asciiValue!
        let n = Character("0").asciiValue!
        
        for i in 0..<26 {
            abc.append(Character(UnicodeScalar(A + UInt8(i))))
        }
        
        for i in 0..<26 {
            abc.append(Character(UnicodeScalar(a + UInt8(i))))
        }
        
        for i in 0..<10 {
            abc.append(Character(UnicodeScalar(n + UInt8(i))))
        }
        
        abc.append("+")
        abc.append("/")
        
        return abc
    }()

    
    func createTonProofItem(address: String, keyPair: TonKeyPair, payload: String) -> ConnectItemReply {
        let timestamp = getTimeSec()
        let timestampData = withUnsafeBytes(of: timestamp) { Data($0) }
        
        let domainValue = getDomainFromURL(manifest.url)!
        let domainLength = getDomainLength(domain: domainValue)
        let domainLengthData = withUnsafeBytes(of: domainLength) { Data($0) }
        let domainData = domainLengthData + domainValue.data(using: .utf8)!
        
        let addressComponents = address.components(separatedBy: ":")
        
        let workchain = Int32(addressComponents[0]) ?? 0
        let workchainData = withUnsafeBytes(of: workchain.bigEndian) { Data($0) }
        
        let addrHash = addressComponents[1].lowercased()
        let addressData = workchainData + Data(hexString: addrHash)!
        
        let messageData = "ton-proof-item-v2/".data(using: .utf8)! + addressData + domainData + timestampData + payload.data(using: .utf8)!
        
        let messageHash = SHA256.hash(data: messageData)
        let dataToSign = Data(hexString: "ffff")! + "ton-connect".data(using: .utf8)! + messageHash
        let sha256ToSign = Data(SHA256.hash(data: dataToSign))
        
        do {
            let secretKey = Data(base64Encoded: keyPair.privateKey)! + Data(base64Encoded: keyPair.publicKey)!
            
            let signed = try NaclSign.signDetached(message: dataToSign, secretKey: secretKey)
            let signature = signed.base64EncodedString()
            
            let domain = Domain(lengthBytes: domainLength, value: domainValue)
            let tonProof = Proof(timestamp: timestamp, domain: domain, payload: payload, signature: signature)
            
            return ConnectItemReply(name: "ton_proof", proof: tonProof)
        } catch {
            print(error.localizedDescription)
            
            fatalError(error.localizedDescription)
        }
    }
    
    func getTimeSec() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    func getDomainFromURL(_ url: String) -> String? {
        if let url = URL(string: url), let host = url.host {
            return host
        }
        
        return nil
    }
    
    func getDomainLength(domain: String) -> UInt32 {
        guard let data = domain.data(using: .utf8) else {
            fatalError("Failed to encode domain to UTF-8 data")
        }
        
        let length = UInt32(data.count)
        return length
    }
    
    
    func generateAppHashFromUrl(_ url: String) -> String {
        let parsedUrl = parseUrl(url)
        
        let hash = SHA256.hash(data: Data(parsedUrl.utf8)).compactMap { String(format: "%02x", $0) }.joined()
        
        return hash
    }
    
    func parseUrl(_ url: String) -> String {
        guard let urlComponents = URLComponents(string: url) else {
            return url
        }
        
        var parsedUrl = url
        if let scheme = urlComponents.scheme, let host = urlComponents.host {
            parsedUrl = "\(scheme)://\(host)"
        }
        
        return parsedUrl
    }
    
    func generateSessionID() -> String {
        var rnd = Data(count: 32)
        rnd.withUnsafeMutableBytes { mutableBytes in
            if let baseAddress = mutableBytes.baseAddress, mutableBytes.count >= 16 {
                let rawBytes = baseAddress.assumingMemoryBound(to: UInt8.self)
                _ = SecRandomCopyBytes(kSecRandomDefault, 32, rawBytes)
            }
        }
        rnd[6] = (rnd[6] & 0x0f) | 0x40
        rnd[8] = (rnd[8] & 0x3f) | 0x80
        
        let hexString = rnd.map { String(format: "%02x", $0) }.joined()
        
        return hexString
    }
    
    func send(response: ConnectEvent) {
        let clientSessionId = model.id
        let naclKeyPair = try! NaclBox.keyPair()
        let sessionId = tonManager.convertBaseToHex(naclKeyPair.publicKey.base64EncodedString())
        
        let url = "https://bridge.tonapi.io/bridge/message?client_id=\(sessionId)&to=\(clientSessionId)&ttl=300"
        
        let baseClientSessionId = tonManager.convertHexToBase(clientSessionId)
        let dataClientSessionId = Data(base64Encoded: baseClientSessionId)!
                
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonDataResponse = try! JSONEncoder().encode(response)
        let stringResponse = String(data: jsonDataResponse, encoding: .utf8)!.data(using: .utf8)!
        
        let nonceLength = 24
        let nonceData = randomBytes(n: nonceLength)
        
        let encrypted = try! NaclBox.box(message: stringResponse, nonce: nonceData, publicKey: dataClientSessionId, secretKey: naclKeyPair.secretKey)
        
        let result = nonceData + encrypted
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = result.base64EncodedString().data(using: .utf8)

        let sseURL = URL(string: "https://bridge.tonapi.io/bridge/events?client_id=\(sessionId)")!
        SSEClient.shared.connectToSSE(url: sseURL)
        
        AF.request(request).response { responseData in
            do {
                if let data = try responseData.result.get() {
                    let json = try JSONSerialization.jsonObject(with: data)

                    print("success", json)
                }
            } catch {
                print("error", error)
            }
        }
    }
    
    let QUOTE: Int = 1 << 16

    func _randomBytes(x: inout Data, n: Int) {
        for i in stride(from: 0, to: n, by: QUOTE) {
            let subarrayCount = min(n - i, QUOTE)
            var subarray = x.subdata(in: i..<i + subarrayCount)
            subarray.withUnsafeMutableBytes { mutableBytes in
                if let baseAddress = mutableBytes.baseAddress {
                    _ = SecRandomCopyBytes(kSecRandomDefault, subarrayCount, baseAddress)
                }
            }
        }
    }
    
    func randomBytes(n: Int) -> Data {
        var b = Data(count: n)
        _randomBytes(x: &b, n: n)
        return b
    }

    
    struct DeviceInfo: Codable {
        let platform: String
        let appName: String
        let appVersion: String
        let maxProtocolVersion: Int
        let features: [Feature]
    }
    
    struct Feature: Codable {
        let name: String
        let maxMessages: Int?
    }
    
    let tonConnectDeviceInfo: DeviceInfo = {
        let platform = "iphone"
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let maxProtocolVersion = 2
        let features: [Feature] = [
            Feature(name: "SendTransaction", maxMessages: nil),
            Feature(name: "SendTransaction", maxMessages: 4)
        ]
        
        return DeviceInfo(platform: platform, appName: appName, appVersion: appVersion, maxProtocolVersion: maxProtocolVersion, features: features)
    }()
    
    struct ConnectEvent: Codable {
        let id: Int
        let event: String
        let payload: Payload
    }
    
    struct Payload: Codable {
        let items: [ConnectItemReply]
        let device: DeviceInfo
    }
    
    struct ConnectItemReply: Codable {
        let name: String
        let address: String?
        let network: Chain?
        let walletStateInit: String?
        let publicKey: String?
        let proof: Proof?
        
        init(name: String, address: String? = nil, network: TonConnectViewController.Chain? = nil, walletStateInit: String? = nil, publicKey: String? = nil, proof: TonConnectViewController.Proof? = nil) {
            self.name = name
            self.address = address
            self.network = network
            self.walletStateInit = walletStateInit
            self.publicKey = publicKey
            self.proof = proof
        }
    }
    
    enum Chain: String, Codable {
        case mainnet = "-239"
        case testnet = "-3"
    }
    
    struct Proof: Codable {
        let timestamp: Int
        let domain: Domain
        let payload: String
        let signature: String
    }
    
    struct Domain: Codable {
        let lengthBytes: UInt32
        let value: String
    }
    
}

// MARK: - TonConnectProviderDelegate

extension TonConnectViewController: TonConnectProviderDelegate {
    func tonConnect(_ provider: TonConnectProvider, manifest: DAppManifest) {
        self.manifest = manifest
    }
    
    func tonConnect(_ provider: TonConnectProvider, failureManifest error: TonConnectError) {
        print(error)
    }
}

extension String {
    func matchingStrings(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound ? nsString.substring(with: result.range(at: $0)) : "" }
        }.flatMap { $0 }
    }
}

extension TonConnectViewController: TonManagerDelegate {
    func ton(stateInitDidCreated result: Result<String, Error>) {
        switch result {
        case .success(let stateInit):
            createResponse(stateInit: stateInit)
        case .failure(let failure):
            fatalError(failure.localizedDescription)
        }
    }
}

extension Data {
    init?(hexString: String) {
        // Remove any spaces or other non-hex characters
        let cleanedString = hexString.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        
        // Ensure the string has an even number of characters
        guard cleanedString.count % 2 == 0 else {
            return nil
        }
        
        // Convert each pair of characters to a byte and create a Data object
        var data = Data(capacity: cleanedString.count / 2)
        var index = cleanedString.startIndex
        while index < cleanedString.endIndex {
            let byteString = cleanedString[index..<cleanedString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = cleanedString.index(index, offsetBy: 2)
        }
        self = data
    }
}

import Foundation

class SSEClient: NSObject, URLSessionDataDelegate {
    
    static let shared = SSEClient()
    
    private var session: URLSession?
    private var task: URLSessionDataTask?
    
    func connectToSSE(url: URL) {
        let sessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        task = session?.dataTask(with: url)
        task?.resume()
    }
    
    // URLSessionDataDelegate methods
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // Обработка полученных данных
        if let message = String(data: data, encoding: .utf8) {
            // Обработка события SSE
            print("Received SSE message: \(message)")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Обработка ошибок или завершения соединения
        if let error = error {
            print("SSE connection error: \(error)")
        }
    }
}
