import UIKit
import LocalAuthentication

class WalletCreatedViewController: UIViewController {

    private var createdWallet: CreatedWallet
    
    private var mainView: WalletCreatedView { view as! WalletCreatedView }
    override func loadView() { view = WalletCreatedView() }
        
    init(createdWallet: CreatedWallet) {
        self.createdWallet = createdWallet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - Private actions
    
    @objc private func nextButtonTapped() {
        let vc = SeedPhraseViewController(mnemonics: createdWallet.mnemonics)
        vc.continueAction = { [weak self] in
            guard let self = self else { return }
            
            let checkMnemonics = CheckSeedViewController(type: .check(createdWallet))
            checkMnemonics.delegate = self
            
            vc.navigationController?.pushViewController(checkMnemonics, animated: true)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func createPassword() {
        let vc = PasswordViewController(type: .create)
        vc.successHandler = { [weak self] password in
            guard let self = self else { return }
            
            DispatchQueue.global().async {
                KeychainManager().storePassword(password)
                KeychainManager().storeMnemonics(self.createdWallet.mnemonics, id: self.createdWallet.wallet.id)
                
                let id = self.createdWallet.wallet.id
                let name = self.createdWallet.wallet.name
                let versionName = self.createdWallet.wallet.activeContract.versionName
                let savedWallet = SavedWallet(id: id, name: name, versionName: versionName)
                
                UserSettings.shared.wallets.append(savedWallet)
            }
            
            offerBiometry()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func offerBiometry() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID, .touchID:
                let biometry = BiometryViewController()
                biometry.disappearHandler = { [weak self] in
                    guard let self = self else { return }
                    self.showSuccess()
                }
                
                present(biometry, animated: true)
                
            case .none: showSuccess()
            @unknown default: showSuccess()
            }
        } else {
            showSuccess()
        }
    }
    
    private func showSuccess() {
        let success = SuccessViewController()
        success.modalPresentationStyle = .overFullScreen
        
        self.present(success, animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
            }
        }
    }
}

// MARK: - CheckSeedDelegate

extension WalletCreatedViewController: CheckSeedDelegate {
    func checkSeed(_ controller: CheckSeedViewController, approved wallet: CreatedWallet) {
        createPassword()
    }
}
