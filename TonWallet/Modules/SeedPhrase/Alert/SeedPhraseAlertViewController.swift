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

        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        let vc = SeedPhraseViewController(type: .read)
        navigationController?.pushViewController(vc, animated: true)
    }
}
