import UIKit
import shared

class SeedPhraseAlertViewController: UIViewController {

    let ton = Ton()

    var mainView: SeedPhraseAlertView {
        return view as! SeedPhraseAlertView
    }

    override func loadView() {
        view = SeedPhraseAlertView()
    }

    // Main -> Paper and pen [start mnemonic generation] -> Creating wallet [generation keypair] -> wallet
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.nextButton.isEnabled = false
        print("Start generate words")
        ton.generateMnemonic { mnemonics, error in
            print("words: ", mnemonics)
            DispatchQueue.main.async {
                // Creating wallet view...
                self.ton.calculateKeyPair(mnemonics: mnemonics!) { keypair, error in
                    print("Address: ", self.ton.walletAddress(publicKey: keypair!.second!))
                    // Wallet view...
                }
            }
        }
        print("after scope")
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        let vc = SeedPhraseViewController(type: .read)
        navigationController?.pushViewController(vc, animated: true)
    }
}
