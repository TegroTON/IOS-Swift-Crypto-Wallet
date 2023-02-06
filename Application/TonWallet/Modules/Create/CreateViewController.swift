import UIKit
import shared

class CreateViewController: UIViewController {

    let queue = DispatchQueue(label: "testQueue", attributes: .concurrent)
    let ton = Ton()

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

        mainView.createNewButton.isEnabled = false

        let seedWords = getSeedWords()
        print("seed words: ", seedWords)

        mainView.createNewButton.isEnabled = true
    }

    @objc private func connectButtonTapped() {
        let vc = SeedPhraseViewController(type: .enter)

        navigationController?.pushViewController(vc, animated: true)
    }

    private func colorAppearanceToggled() {
        mainView.updateColors()
    }

    func getSeedWords() -> [String] {
        let kotlinArray = ton.generateMnemonic()
        var swiftArray = [String]()

        let count = kotlinArray.size
        for index in 0..<count {
            let string = kotlinArray.get(index: index)! as String
            swiftArray.append(string)
        }

        return swiftArray
    }

}
