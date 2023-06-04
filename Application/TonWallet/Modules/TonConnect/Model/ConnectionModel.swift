import Foundation

struct ConnectionModel: Codable {
    enum TonConnectBridgeType: String, Codable {
      case remote = "remote"
      case injected = "injected"
    }
    
    let type: TonConnectBridgeType
    let sessionKeyPair: KeyPair
    let clientSessionId: String
    let replyItems: [ConnectItemReply]
    let manifest: DAppManifest
    let address: String
}
    
