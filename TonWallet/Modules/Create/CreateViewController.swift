import UIKit

class CreateViewController: UIViewController {

    var mainView: CreateView {
        return view as! CreateView
    }
    
    override func loadView() {
        view = CreateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.createNewButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            colorAppearanceToggled()
        }
    }
    
    @objc private func createButtonTapped() {
        let vc = SeedPhraseAlertViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func colorAppearanceToggled() {
        mainView.updateColors()
    }
    
}
