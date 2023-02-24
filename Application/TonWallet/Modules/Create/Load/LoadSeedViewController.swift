import UIKit

class LoadSeedViewController: UIViewController {

    var mainView: LoadSeedView {
        return view as! LoadSeedView
    }
    
    private let manager = TonManager.shared
    private var createdWallet: Wallet!

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
            createdWallet = WalletManager.shared.createWallet(mnemonics: <#T##[String]##[Swift.String]#>)
            manager.calculateKeyPair(mnemonics: mnemonics)

        case .failure(let error):
            print("❤️ mnemonics generate error", error)
        }
    }
    
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) {
        switch result {
        case .success(let keys):
            WalletManager.shared.setKeys(keys, for: createdWallet.id)
            mainView.animateView.needToStopAnimation = true
            
        case .failure(let error):
            print("❤️ keyPairCalculated error", error)
        }
    }
}
