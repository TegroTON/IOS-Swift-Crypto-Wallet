import UIKit

class SeedPhraseAlertViewController: UIViewController {

    var mainView: SeedPhraseAlertView {
        return view as! SeedPhraseAlertView
    }

    override func loadView() {
        view = SeedPhraseAlertView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        let vc = SeedPhraseViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
