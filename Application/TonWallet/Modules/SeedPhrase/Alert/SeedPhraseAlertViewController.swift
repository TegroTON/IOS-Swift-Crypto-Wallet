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

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.nextButton.isEnabled = false
        print("Start generate words")
        ton.generateMnemonic { words, error in
            print("words: ", words)
            DispatchQueue.main.async {
                self.mainView.nextButton.isEnabled = true
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
