import UIKit
import LocalAuthentication

class CreateViewController: UIViewController {
    
    private var mainView: CreateView { view as! CreateView }
    override func loadView() { view = CreateView() }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return traitCollection.userInterfaceStyle == .light ? .darkContent : .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        mainView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        mainView.connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createButtonTapped() {
        navigationController?.pushViewController(LoadSeedViewController(), animated: true)
    }
    
    @objc private func connectButtonTapped() {
        let checkSeed = CheckSeedViewController(type: .create)
        checkSeed.delegate = self
        
        navigationController?.pushViewController(checkSeed, animated: true)
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

extension CreateViewController: CheckSeedDelegate {
    func checkSeed(_ controller: CheckSeedViewController, approved wallet: CreatedWallet) {
        let password = PasswordViewController(type: .create)
        password.successHandler = { [weak self] password in
            guard let self = self else { return }
            
            DispatchQueue.global().async {
                KeychainManager().storePassword(password)
                KeychainManager().storeMnemonics(wallet.mnemonics, id: wallet.wallet.id)
                
                let id = wallet.wallet.id
                let name = wallet.wallet.name
                let versionName = wallet.wallet.activeContract.versionName
                let savedWallet = SavedWallet(id: id, name: name, versionName: versionName)
                
                UserSettings.shared.wallets.append(savedWallet)
            }
            
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
        
        navigationController?.pushViewController(password, animated: true)
    }
    
    
}
