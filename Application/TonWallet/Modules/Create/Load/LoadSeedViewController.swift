import UIKit

class LoadSeedViewController: UIViewController {

    var mainView: LoadSeedView {
        return view as! LoadSeedView
    }
    
    private let tonManager = TonManager.shared
    private let walletManager = WalletManager.shared
    private var createdWallet: Wallet!

    override func loadView() {
        view = LoadSeedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tonManager.delegate = self
        tonManager.generateMnemonic()
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
            createdWallet = walletManager.create(wallet: mnemonics)
            tonManager.calculateKeyPair(mnemonics: mnemonics)
            
        case .failure(let error):
            print("❤️ mnemonics generate error", error)
        }
    }
    
    func ton(keyPairCalculated result: Result<TonKeyPair, Error>) {
        switch result {
        case .success(let keys):
            walletManager.set(keys: keys, for: createdWallet.id)
            mainView.animateView.needToStopAnimation = true
            
        case .failure(let error):
            print("❤️ keyPairCalculated error", error)
        }
    }
}
