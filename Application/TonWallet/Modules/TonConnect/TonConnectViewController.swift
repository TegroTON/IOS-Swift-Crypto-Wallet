import UIKit
import Kingfisher
import CryptoKit
import Alamofire
import CommonCrypto
import TweetNacl

class TonConnectViewController: ModalScrollViewController {
    
    private var model: ConnectQuery
    private let tonManager: TonManager = .shared
    private let userSettings: UserSettings = .shared
    private let provider: TonConnectProvider = .init()
    #warning("need to implement selectedWallet or somthing like that in WalletManager")
    private let wallet = WalletManager.shared.wallets.first!
    private var keyPair: TonKeyPair?
    
    private let tonConnectDeviceInfo: DeviceInfo = {
        let platform = "iphone"
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let maxProtocolVersion = 2
        let features: [DeviceFeature] = [
            DeviceFeature(name: "SendTransaction", maxMessages: nil),
            DeviceFeature(name: "SendTransaction", maxMessages: 4)
        ]
        
        return DeviceInfo(platform: platform, appName: appName, appVersion: appVersion, maxProtocolVersion: maxProtocolVersion, features: features)
    }()
    
    private var manifest: DAppManifest! {
        didSet {
            updateContent()
        }
    }
    
    private let viewModel: TonConnectViewModel = .init()
    private var mainView: TonConnectView { modalView as! TonConnectView }
    override func loadModalView() { modalView = TonConnectView() }
    
    init(model: ConnectQuery) {
        self.model = model
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyPair = KeychainManager().getKey(id: wallet.id)!
        
        provider.delegate = self
        provider.requestManifest(with: model.request.manifestUrl)
        
        mainView.allowButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private actions
    
    @objc private func connectButtonTapped() {
        let replyItems = createReplyItems(keyPair: keyPair!)
        let payload = Payload(items: replyItems, device: tonConnectDeviceInfo)
        let event = TonConnectEvent(id: 0, event: "connect", payload: payload)
        
        send(event: event)
    }
    
    // MARK: - Private methods
        
    private func updateContent() {
        let walletVersion = wallet.selectedAddress?.name ?? ""
        let walletAddress = wallet.selectedAddress?.address ?? ""
        let domain = getDomainFromURL(manifest.url) ?? "unknown domain"
        
        mainView.set(name: manifest.name)
        mainView.set(icon: manifest.iconUrl)
        mainView.set(accessTo: domain, wallet: walletAddress, version: walletVersion)
    }
    
    private func createReplyItems(keyPair: TonKeyPair) -> [ConnectItemReply] {
        let address = tonManager.getAddress(.v4r2, publicKey: keyPair.publicKey, isUserFriendly: false).address.lowercased()
        var replyItems = [ConnectItemReply]()
        
        let wallet = WalletV4R2(publicKey: Data(base64Encoded: keyPair.publicKey)!)
        let codeBOC = try! wallet.stateInit.code!.toBoc()
        let walletStateInit = codeBOC.base64EncodedString()
        
        model.request.items.forEach { item in
            switch item.name {
            case "ton_addr":
                let addressItem = ConnectItemReply(
                    name: "ton_addr",
                    address: address,
                    network: .mainnet,
                    walletStateInit: walletStateInit,
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
    
    private func createTonProofItem(address: String, keyPair: TonKeyPair, payload: String) -> ConnectItemReply {
        let timestamp = Int(Date().timeIntervalSince1970)
        let timestampData = withUnsafeBytes(of: timestamp) { Data($0) }
        
        let domainValue = getDomainFromURL(manifest.url)!
        let domainLength = getDomainLength(domain: domainValue)
        let domainLengthData = withUnsafeBytes(of: domainLength) { Data($0) }
        let domainData = domainLengthData + domainValue.data(using: .utf8)!
        
        let addressComponents = address.components(separatedBy: ":")
        
        let workchain = Int32(addressComponents[0]) ?? 0
        let workchainData = withUnsafeBytes(of: workchain.bigEndian) { Data($0) }
        
        let addrHash = addressComponents[1].lowercased()
        let addressData = workchainData + Data(hex: addrHash)!
        
        let messageData = "ton-proof-item-v2/".data(using: .utf8)! + addressData + domainData + timestampData + payload.data(using: .utf8)!
        
        let messageHash = SHA256.hash(data: messageData)
        let dataToSign = Data(hex: "ffff")! + "ton-connect".data(using: .utf8)! + messageHash
//        let sha256ToSign = Data(SHA256.hash(data: dataToSign))
        
        do {
            let secretKey = Data(base64Encoded: keyPair.privateKey)! + Data(base64Encoded: keyPair.publicKey)!
            
            let signed = try NaclSign.signDetached(message: dataToSign, secretKey: secretKey)
            let signature = signed.base64EncodedString()
            
            let domain = Domain(lengthBytes: domainLength, value: domainValue)
            let tonProof = TonProof(timestamp: timestamp, domain: domain, payload: payload, signature: signature)
            
            return ConnectItemReply(name: "ton_proof", proof: tonProof)
        } catch {
            print(error.localizedDescription)
            
            fatalError(error.localizedDescription)
        }
    }
    
    private func getDomainFromURL(_ url: String) -> String? {
        if let url = URL(string: url), let host = url.host {
            return host
        }
        
        return nil
    }
    
    private func getDomainLength(domain: String) -> UInt32 {
        guard let data = domain.data(using: .utf8) else {
            fatalError("Failed to encode domain to UTF-8 data")
        }
        
        let length = UInt32(data.count)
        return length
    }
                
    private func send(event: TonConnectEvent) {
        do {
            let sessionCrypto = SessionCrypto()
            let eventData = try JSONEncoder().encode(event)
            
            guard
                let eventString = String(data: eventData, encoding: .utf8),
                let receiverPublicKey = Data(hex: model.id)
            else {
                sendError()
                return
            }
            
            let message = try sessionCrypto.encrypt(
                message: eventString,
                receiverPublicKey: receiverPublicKey
            )
            
            saveConnection(connection: ConnectionModel(
                type: .remote,
                sessionKeyPair: sessionCrypto.keyPair,
                clientSessionId: model.id,
                replyItems: event.payload.items,
                manifest: manifest,
                address: wallet.selectedAddress!.address
            ))
            
            provider.tonConnect(message: message, clientId: sessionCrypto.sessionId, sessionId: model.id)
        } catch {
            print(error)
            sendError()
        }
    }
    
    #warning("TODO: need implement methods")
    private func sendError() { }
    private func saveConnection(connection: ConnectionModel) {
        userSettings.connections.append(connection)
    }
}

// MARK: - TonConnectProviderDelegate

extension TonConnectViewController: TonConnectProviderDelegate {
    func tonConnect(_ provider: TonConnectProvider, isConnectSuccessed: Bool) {
        dismiss(animated: true)
    }
    
    func tonConnect(_ provider: TonConnectProvider, manifest: DAppManifest) {
        self.manifest = manifest
    }
    
    func tonConnect(_ provider: TonConnectProvider, failureManifest error: TonConnectError) {
        print(error)
    }
}
