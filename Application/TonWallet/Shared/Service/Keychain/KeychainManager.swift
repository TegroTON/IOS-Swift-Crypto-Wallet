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
            let privateKeyTag = KeyType.privateKey(id: id).value
            let publicKeyTag = KeyType.publicKey(id: id).value
            
            let privateKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: privateKeyTag,
                kSecValueData as String: privateKey
            ]
            
            let publicKeyAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: publicKeyTag,
                kSecValueData as String: publicKey
            ]
            
            let privateKeyDeleteStatus = SecItemDelete(privateKeyAttributes as CFDictionary)
            let publicKeyDeleteStatus = SecItemDelete(publicKeyAttributes as CFDictionary)
            
            let privateKeyAddStatus = SecItemAdd(privateKeyAttributes as CFDictionary, nil)
            let publicKeyAddStatus = SecItemAdd(publicKeyAttributes as CFDictionary, nil)
            
            let isSuccess = privateKeyDeleteStatus == errSecSuccess &&
            publicKeyDeleteStatus == errSecSuccess &&
            privateKeyAddStatus == errSecSuccess &&
            publicKeyAddStatus == errSecSuccess
            
            DispatchQueue.main.async {
                completion?(isSuccess)
            }
        }
    }
    
    func storeMnemonics(_ mnemonics: [String], id: String, completion: ((Bool) -> Void)? = nil) {
        keychainQueue.async {
            let mnemonicsAttributes: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrApplicationTag as String: "\(Bundle.main.bundleIdentifier!).\(id).mnemonics",
                kSecValueData as String: mnemonics.joined(separator: ";")
            ]
            
            let mnemonicsDeleteStatus = SecItemDelete(mnemonicsAttributes as CFDictionary)
            let mnemonicsAddStatus = SecItemAdd(mnemonicsAttributes as CFDictionary, nil)
            
            DispatchQueue.main.async {
                completion?(mnemonicsDeleteStatus == errSecSuccess && mnemonicsAddStatus == errSecSuccess)
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
            
            if status == errSecSuccess, let key = keyTypeRef as? String {
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
            
            if status == errSecSuccess, let string = mnemonicsTypeRef as? String {
                let array = string.components(separatedBy: ";")
                return array
            }
            
            return nil
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
