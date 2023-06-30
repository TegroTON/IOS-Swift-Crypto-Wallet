import Security
import Foundation

class KeychainManager {
    
    let keychainQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).keychain")
    
    // MARK: - Store methods
    
    func storePassword(_ password: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            guard let data = password.data(using: .utf8) else {
                completion?(false)
                return
            }
            
            let passwordAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).password",
                kSecValueData as String: data
            ]
            
            _ = SecItemDelete(passwordAttributes as CFDictionary)
            let passwordAddStatus = SecItemAdd(passwordAttributes as CFDictionary, nil)
            
            DispatchQueue.main.async {
                completion?(passwordAddStatus == errSecSuccess)
            }
        }
    }
    
    func storeMnemonics(_ mnemonics: [String], id: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let data = mnemonics.joined(separator: ";").data(using: .utf8)!
            
            let mnemonicsAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).mnemonics",
                kSecValueData as String: data
            ]
            
            let mnemonicsAddStatus = SecItemAdd(mnemonicsAttributes as CFDictionary, nil)
            
            DispatchQueue.main.async {
                completion?(mnemonicsAddStatus == errSecSuccess)
            }
        }
    }
    
    // MARK: - Get methods
    
    func getPassword() -> String? {
        keychainQueue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).password",
                kSecReturnData as String: true
            ]
            
            var passwordTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &passwordTypeRef)
            
            guard
                status == errSecSuccess,
                let data = passwordTypeRef as? Data,
                let password = String(data: data, encoding: .utf8)
            else { return nil }
            
            return password
        }
    }
    
    func getMnemonics(id: String) -> [String]? {
        keychainQueue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).mnemonics",
                kSecReturnData as String: true
            ]
            
            var mnemonicsTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &mnemonicsTypeRef)
            
            if status == errSecSuccess, let data = mnemonicsTypeRef as? Data, let string = String(data: data, encoding: .utf8) {
                let array = string.components(separatedBy: ";")
                
                return array
            }
            
            return nil
        }
    }
    
    // MARK: - Delete methods
    
    func deletePassword(completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).password",
            ]
            
            let mnemonicsDeleteStatus = SecItemDelete(query as CFDictionary)
            
            completion?(mnemonicsDeleteStatus == errSecSuccess)
        }
    }
    
    func deleteMnemonics(for id: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let mnemonicsAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).mnemonics",
            ]
            
            let mnemonicsDeleteStatus = SecItemDelete(mnemonicsAttributes as CFDictionary)
            
            completion?(mnemonicsDeleteStatus == errSecSuccess)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @available(*, deprecated, message: "This method not use TonSwift")
    func storeKeys(id: String, keyPair: TonKeyPair, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            guard let data = try? JSONEncoder().encode(keyPair) else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }

            let keysAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).keyPair",
                kSecValueData as String: data
            ]

            let _ = SecItemDelete(keysAttributes as CFDictionary)

            let keysAddStatus = SecItemAdd(keysAttributes as CFDictionary, nil)

            DispatchQueue.main.async {
                completion?(keysAddStatus == errSecSuccess)
            }
        }
    }
    
    @available(*, deprecated, message: "This method not use TonSwift")
    func getKey(id: String) -> TonKeyPair? {
        keychainQueue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).keyPair",
                kSecReturnData as String: true
            ]
            
            var keysTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &keysTypeRef)
            
            if status == errSecSuccess, let data = keysTypeRef as? Data {
                return try? JSONDecoder().decode(TonKeyPair.self, from: data)
            }
            
            return nil
        }
    }
    
    @available(*, deprecated, message: "This method not use TonSwift")
    func deleteKeys(for id: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let keysAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).keyPair",
            ]
                
            let keysDeleteStatus = SecItemDelete(keysAttributes as CFDictionary)
            
            completion?(keysDeleteStatus == errSecSuccess)
        }
    }
}
