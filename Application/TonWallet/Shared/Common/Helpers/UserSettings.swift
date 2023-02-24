import Foundation

class UserSettings {
    
    static let defaults = UserDefaults.standard
    
    static var wallets: Data? {
        get {
            return defaults.data(forKey: #function)
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
}
