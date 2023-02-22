import UIKit

class SeedPhraseViewController: UIViewController {
    
    var mainView: SeedPhraseView {
        return view as! SeedPhraseView
    }
    
    let phrases = TonManager.shared.mnemonics ?? []
        
    override func loadView() {
        view = SeedPhraseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        configureSeedStack()
    }
    
    @objc private func nextButtonTapped() {
        navigationController?.pushViewController(CheckSeedViewController(type: .check), animated: true)
    }
        
    private func configureSeedStack() {
        for (index, word) in phrases.enumerated() {
            let view = SeedWordView(index: index + 1, word: word)
            
            if index < 12 {
                mainView.leftStackView.addArrangedSubview(view)
            } else {
                mainView.rightStackView.addArrangedSubview(view)
            }
        }        
    }
}
