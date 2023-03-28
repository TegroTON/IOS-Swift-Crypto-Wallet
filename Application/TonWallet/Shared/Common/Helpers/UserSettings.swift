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
    
    static var blockDate: Date? {
        get {
            return defaults.object(forKey: #function) as? Date
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
}
