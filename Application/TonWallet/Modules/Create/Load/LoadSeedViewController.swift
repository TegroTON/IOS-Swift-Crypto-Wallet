import UIKit

class LoadSeedViewController: UIViewController {

    var mainView: LoadSeedView {
        return view as! LoadSeedView
    }
    
    let manager = TonManager.shared
    
    override func loadView() {
        view = LoadSeedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.generateMnemonic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.animateView.startAnimation { [weak self] in
            self?.navigationController?.pushViewController(SeedPhraseAlertViewController(), animated: true)
        }
    }
    
}

// MARK: - TonManagerDelegate

extension LoadSeedViewController: TonManagerDelegate {
    func ton(mnemonicsDidGenerated result: Result<[String], Error>) {
        switch result {
        case .success(let mnemonics):
            print("💜 success mnemonic")
            manager.calculateKeyPair(mnemonics: mnemonics)
            print("💜 after key pair")

        case .failure(let error):
            print("❤️ mnemonics generate error", error)
        }
    }
    
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) {
        switch result {
        case .success:
            mainView.animateView.needToStopAnimation = true
            
        case .failure(let error):
            print("❤️ keyPairCalculated error", error)
        }
    }
}
