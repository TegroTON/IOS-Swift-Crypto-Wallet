import Foundation

class UserSettings {
    
    static let shared = UserSettings()
    
    @UserDefaultWrapper(key: "wallets", defaultValue: [])
    var wallets: [SavedWallet]
        
    @UserDefaultWrapper(key: "blockDate", defaultValue: nil)
    var blockDate: Date?
    
    @UserDefaultWrapper(key: "connections", defaultValue: [])
    var connections: [ConnectionModel]
    
    @UserDefaultWrapper(key: "lastEventId", defaultValue: nil)
    var lastEventId: Int?
    
    @UserDefaultWrapper(key: "biometryEnabled", defaultValue: false)
    var biometryEnabled: Bool
    
    func logout() {
        lastEventId = nil
        blockDate = nil
        wallets = []
        connections = []
        biometryEnabled = false
    }
}
