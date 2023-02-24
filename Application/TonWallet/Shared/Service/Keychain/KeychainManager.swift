import Security
import Foundation

class KeychainManager {
    
    enum KeyType {
        case privateKey(id: String)
        case publicKey(id: String)
        
        var value: String {
            let bundle = Bundle.main.bundleIdentifier!

            switch self {
            case .privateKey(let id):
                return "\(bundle).\(id).privateKey"

            case .publicKey(let id):
                return "\(bundle).\(id).publicKey"
            }
        }
    }
    
    let keychainQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).keychain")
    
    func storeKeys(id: String, publicKey: String, privateKey: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            guard
                let privateData = privateKey.data(using: .utf8),
                let publicData = publicKey.data(using: .utf8)
            else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }
            
            let privateKeyTag = KeyType.privateKey(id: id).value
            let publicKeyTag = KeyType.publicKey(id: id).value
            
            let privateKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: privateKeyTag,
                kSecValueData as String: privateData
            ]
            
            let publicKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: publicKeyTag,
                kSecValueData as String: publicData
            ]
            
            let _ = SecItemDelete(privateKeyAttributes as CFDictionary)
            let _ = SecItemDelete(publicKeyAttributes as CFDictionary)
                        
            let privateKeyAddStatus = SecItemAdd(privateKeyAttributes as CFDictionary, nil)
            let publicKeyAddStatus = SecItemAdd(publicKeyAttributes as CFDictionary, nil)
                        
            DispatchQueue.main.async {
                completion?(privateKeyAddStatus == errSecSuccess && publicKeyAddStatus == errSecSuccess)
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
    
    func getKey(keyType: KeyType) -> String? {
        keychainQueue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: keyType.value,
                kSecReturnData as String: true
            ]
            
            var keyTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &keyTypeRef)
            
            if status == errSecSuccess, let data = keyTypeRef as? Data, let key = String(data: data, encoding: .utf8) {
                return key
            }
            
            return nil
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
    
    func deleteKeys(for id: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let privateKeyTag = KeyType.privateKey(id: id).value
            let publicKeyTag = KeyType.publicKey(id: id).value
            
            let privateKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: privateKeyTag,
            ]
            
            let publicKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: publicKeyTag,
            ]
            
            let privateKeyDeleteStatus = SecItemDelete(privateKeyAttributes as CFDictionary)
            let publicKeyDeleteStatus = SecItemDelete(publicKeyAttributes as CFDictionary)
            
            completion?(privateKeyDeleteStatus == errSecSuccess && publicKeyDeleteStatus == errSecSuccess)
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
    
}
