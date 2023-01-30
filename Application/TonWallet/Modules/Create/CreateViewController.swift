import UIKit
import shared

class CreateViewController: UIViewController {

    let queue = DispatchQueue(label: "testQueue", attributes: .concurrent)
    
    var mainView: CreateView {
        return view as! CreateView
    }
    
    override func loadView() {
        view = CreateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.createNewButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        mainView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            colorAppearanceToggled()
        }
    }
    
    @objc private func createButtonTapped() {
//        let vc = SeedPhraseAlertViewController()
//
//        navigationController?.pushViewController(vc, animated: true)
        
        let ton = Ton()
        let mnemonic = MnemonicCompanion.shared
        let liteClient = ton.doInitLiteClient()
        
//        mnemonic.doGenerate { array, error in
//
//        }
//        mnemonic.generate(wordCount: 24, password: "", wordlist: mnemonic.DEFAULT_WORDLIST, random: KotlinRandom()) { array, error in
//            print("fuck this shit", array)
//        }
//        let wallet = ton.mnemonicGeneration()
    }
    
    @objc private func connectButtonTapped() {
        let vc = SeedPhraseViewController(type: .enter)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func colorAppearanceToggled() {
        mainView.updateColors()
    }
    
}
