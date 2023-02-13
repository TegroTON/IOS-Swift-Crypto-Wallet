import UIKit
import shared

class SeedPhraseAlertViewController: UIViewController {

    let manager = TonManager.shared

    var mainView: SeedPhraseAlertView {
        return view as! SeedPhraseAlertView
    }

    override func loadView() {
        view = SeedPhraseAlertView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self

        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        generateMnemonic()
    }

    @objc private func nextButtonTapped() {
        let vc = SeedPhraseViewController(type: .read)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func generateMnemonic() {
        mainView.nextButton.isEnabled = false
        manager.generateMnemonic()
    }

}

extension SeedPhraseAlertViewController: TonManagerDelegate {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>) {
        switch result {
        case .success(let mnemonics):
            mainView.nextButton.isEnabled = true
            manager.calculateKeyPair(mnemonics: mnemonics)

        case .failure(let error):
            print("❤️ mnemonics generate error", error)
        }
    }
}
