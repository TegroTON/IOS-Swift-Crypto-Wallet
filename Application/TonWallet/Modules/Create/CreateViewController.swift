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
        let liteClient = ton.doInitLiteClient()
        let seedWords = getSeedWords()
        
        
    }
    
    @objc private func connectButtonTapped() {
        let vc = SeedPhraseViewController(type: .enter)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func colorAppearanceToggled() {
        mainView.updateColors()
    }
    
    func getSeedWords() -> [String] {
        let kotlinArray = MnemonicCompanion.shared.doGenerate()
        var swiftArray = [String]()
        
        if let count = kotlinArray?.size, let kotlinArray = kotlinArray {
            for index in 0..<count {
                let string = kotlinArray.get(index: index)! as String
                swiftArray.append(string)
            }
        }
        
        return swiftArray
    }
    
}
