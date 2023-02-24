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
        
    func storeKeys(id: String, publicKey: String, privateKey: String) -> Bool {
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
        
        return privateKeyDeleteStatus == errSecSuccess &&
        publicKeyDeleteStatus == errSecSuccess &&
        privateKeyAddStatus == errSecSuccess &&
        publicKeyAddStatus == errSecSuccess
    }
    
    func getKey(keyType: KeyType) -> String? {
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
    
    func deleteKeys(for id: String) -> Bool {
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
        
        return privateKeyDeleteStatus == errSecSuccess && publicKeyDeleteStatus == errSecSuccess
    }
    
}
