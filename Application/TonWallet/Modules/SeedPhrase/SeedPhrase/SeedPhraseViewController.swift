import UIKit

class SeedPhraseViewController: UIViewController {
    
    var continueAction: (() -> Void)?
    private var mnemonics: [String]
    
    private var mainView: SeedPhraseView { view as! SeedPhraseView }
    override func loadView() { view = SeedPhraseView() }
    
    init(mnemonics: [String]) {
        self.mnemonics = mnemonics
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        mainView.headerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.headerView.copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        
        mainView.nextButton.isHidden = continueAction == nil
        
        configureSeedStack()
    }
    
    @objc private func nextButtonTapped() {
        continueAction?()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func copyButtonTapped() {
        UIPasteboard.general.strings = mnemonics
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        ToastController.showNotification(title: localizable.toastMnemonics())
    }
        
    private func configureSeedStack() {
        for (index, word) in mnemonics.enumerated() {
            let view = SeedWordView(index: index + 1, word: word)
            
            if index < 12 {
                mainView.leftStackView.addArrangedSubview(view)
            } else {
                mainView.rightStackView.addArrangedSubview(view)
            }
        }        
    }
}
