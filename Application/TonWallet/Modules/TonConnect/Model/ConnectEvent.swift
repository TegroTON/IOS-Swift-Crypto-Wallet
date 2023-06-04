import Foundation

struct TonConnectEvent: Codable {
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
    let proof: TonProof?
    
    enum Chain: String, Codable {
        case mainnet = "-239"
        case testnet = "-3"
    }
    
    init(name: String, address: String? = nil, network: Chain? = nil, walletStateInit: String? = nil, publicKey: String? = nil, proof: TonProof? = nil) {
        self.name = name
        self.address = address
        self.network = network
        self.walletStateInit = walletStateInit
        self.publicKey = publicKey
        self.proof = proof
    }
}

struct TonProof: Codable {
    let timestamp: Int
    let domain: Domain
    let payload: String
    let signature: String
}

struct Domain: Codable {
    let lengthBytes: UInt32
    let value: String
}

struct DeviceInfo: Codable {
    let platform: String
    let appName: String
    let appVersion: String
    let maxProtocolVersion: Int
    let features: [DeviceFeature]
}

struct DeviceFeature: Codable {
    let name: String
    let maxMessages: Int?
}
