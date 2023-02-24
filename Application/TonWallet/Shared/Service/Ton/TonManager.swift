import Foundation
import shared

class TonManager {

    weak var delegate: TonManagerDelegate?

    static let shared: TonManager = TonManager()

    let ton = Ton()
    var mnemonics: [String]?
    var keyPair: TonKeyPair?

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

    func calculateKeyPair(mnemonics: [String]) {
        self.ton.calculateKeyPair(mnemonics: mnemonics) { keyPair, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.keyPair = nil
                    self.delegate?.ton(keyPairCalculated: .failure(error))
                } else if let keyPair = keyPair, let privateKey = keyPair.first as? String, let publicKey = keyPair.second as? String {
                    let keyPair = TonKeyPair(privateKey: privateKey, publicKey: publicKey)
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

}