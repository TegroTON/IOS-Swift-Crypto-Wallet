import TweetNacl
import CTweetNacl

class SessionCrypto {
    enum SessionCryptoError: Error {
        case messageNotValid
        case getStringFromDecripted
    }
    
    let keyPair: KeyPair
    let sessionId: String
    private let nonceLength: Int = 24
    
    init(keyPair: KeyPair? = nil) {
        if let keyPair = keyPair {
            self.keyPair = keyPair
        } else {
            do {
                let keyPair = try NaclBox.keyPair()
                self.keyPair = KeyPair(publicKey: keyPair.publicKey, secretKey: keyPair.secretKey)
            } catch {
                print("❤️ failure create SessionCrypto keyPair")
                self.keyPair = KeyPair(publicKey: Data(), secretKey: Data())
            }
        }
        
        sessionId = self.keyPair.publicKey.hexString()
    }
    
    func encrypt(message: String, receiverPublicKey: Data) throws -> Data {
        guard let encodedMessage = message.data(using: .utf8) else {
            throw SessionCryptoError.messageNotValid
        }
        let nonce = createNonce()
        let encrypted = try NaclBox.box(message: encodedMessage, nonce: nonce, publicKey: receiverPublicKey, secretKey: keyPair.secretKey)
        
        return nonce + encrypted
    }
    
    func decrypt(message: Data, senderPublicKey: Data) throws -> Data {
        let nonce = message.prefix(nonceLength)
        let internalMessage = message.suffix(from: nonceLength)
        
        let decrypted = try NaclBox.open(message: internalMessage, nonce: nonce, publicKey: senderPublicKey, secretKey: keyPair.secretKey)
        
        return decrypted
    }
    
    private func createNonce() -> Data {
        return Data(randomBytes: nonceLength)
    }
}
