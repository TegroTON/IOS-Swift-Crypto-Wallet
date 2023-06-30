import Foundation
import CryptoKit
import shared

typealias AddressType = TonManager.AddressType

class TonManager {

    enum AddressType: String {
        case v4r2 = "V4R2"
    }
    
    weak var delegate: TonManagerDelegate?

    static let shared: TonManager = TonManager()

    let ton = Ton()
    var mnemonics: [String]?
    var keyPair: TonKeyPair?

    @available(*, deprecated, message: "This method not use TonSwift")
    func generateMnemonic() {
        ton.generateMnemonic { mnemonics, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.mnemonics = nil
                    self.delegate?.ton(mnemonicsDidGenerated: .failure(error))
                } else if let mnemonics = mnemonics {
                    self.mnemonics = mnemonics
                    self.delegate?.ton(mnemonicsDidGenerated: .success(mnemonics))
                } else {
                    self.mnemonics = nil
                    let error = NSError(domain: "Unkhown generate mnemonic error", code: -1)
                    self.delegate?.ton(mnemonicsDidGenerated: .failure(error))
                }
            }
        }
    }

    @available(*, deprecated, message: "This method not use TonSwift")
    func calculateKeyPair(mnemonics: [String]) {
        self.ton.calculateKeyPair(mnemonics: mnemonics) { keyPair, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.keyPair = nil
                    self.delegate?.ton(keyPairCalculated: .failure(error))
                } else if let keyPair = keyPair {
                    let keyPair = TonKeyPair(privateKey: keyPair.privateKey, publicKey: keyPair.publicKey)
                    self.keyPair = keyPair
                    self.delegate?.ton(keyPairCalculated: .success(keyPair))
                } else {
                    self.keyPair = nil
                    let error = NSError(domain: "Unkhown calculate key pair error", code: -1)
                    self.delegate?.ton(keyPairCalculated: .failure(error))
                }
            }
        }
    }
    
    @available(*, deprecated, message: "This method not use TonSwift")
    func getAddress(_ type: AddressType, publicKey: String, isUserFriendly: Bool = true) -> WalletAddress {
        switch type {
        case .v4r2:
            let address = ton.walletAddress(pbKey: publicKey, isUserFriendly: isUserFriendly)
            let name = type.rawValue
            return WalletAddress(name: name, address: address)
        }
    }

    @available(*, deprecated, message: "This method not use TonSwift")
    func convertKeyToHex(_ key: String) -> String {
        let hexKey = ton.keyToHex(pbKey: key)
        return hexKey
    }

    @available(*, deprecated, message: "This method not use TonSwift")
    func createStateInit(pbKey: String) {
        let stateInit = ton.createStateInit(publicKey: pbKey)

        delegate?.ton(stateInitDidCreated: .success(stateInit))
    }

    @available(*, deprecated, message: "This method not use TonSwift")
    func convertBaseToHex(_ base64: String) -> String {
        let hex = ton.baseToHex(base64: base64)
        return hex
    }

    @available(*, deprecated, message: "This method not use TonSwift")
    func convertHexToBase(_ hex: String) -> String {
        let base64 = ton.hexToBase(hex: hex)
        return  base64
    }
}
