import UIKit

class LoadSeedViewController: UIViewController {
    
    private let createQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).createWallet")
    private var mainView: LoadSeedView { view as! LoadSeedView }
    override func loadView() { view = LoadSeedView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        createWallet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.animateView.startAnimation { [weak self] wallet in
            guard let wallet = wallet as? CreatedWallet else {
                // TODO: Show error "something gone wronge"
                self?.navigationController?.popViewController(animated: true)
                return
            }
            
            self?.navigationController?.pushViewController(WalletCreatedViewController(createdWallet: wallet), animated: true)
        }
    }
    
    private func createWallet() {
        WalletManager.shared.createNewWallet { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let createdWallet):
                    self?.mainView.animateView.stopAnimation(with: createdWallet)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: Show error "error.localizedDescription"
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
