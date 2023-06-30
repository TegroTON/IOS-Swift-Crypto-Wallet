import UIKit
import IGListKit

class WalletViewController: UIViewController {

    var mainView: WalletView {
        return view as! WalletView
    }
    
    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    
    override func loadView() {
        view = WalletView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.collectionView = mainView.collectionView
        adapter.dataSource = self
        
        mainView.headerView.scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private actions
    
    @objc private func scanButtonTapped() {
        let vc = ScanViewController()
        vc.modalPresentationStyle = .automatic
        vc.delegate = self
        
        present(vc, animated: true)
    }

}

// MARK: - ListAdapterDataSource

extension WalletViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            WalletsSectionModel(wallets: WalletManager.shared.wallets)
        ]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is WalletsSectionModel:
            let section = WalletsSection()
            section.delegate = self
            
            return section
            
        default:
            preconditionFailure("Unknown object type")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}

// MARK: - WalletsSectionDelegate

extension WalletViewController: WalletsSectionDelegate {
    func wallets(_ section: WalletsSection, sendFrom wallet: WalletNew) {
        let navVC = RootNavigationController(rootViewController: SendViewController())
        navVC.modalPresentationStyle = .overFullScreen
        
        present(navVC, animated: true)
    }
    
    func wallets(_ section: WalletsSection, receiveTo wallet: WalletNew) {
        let receive = ReceiveViewController(wallet: wallet)
        receive.modalPresentationStyle = .overFullScreen
        receive.modalTransitionStyle = .crossDissolve
        
        present(receive, animated: true)
    }
    
    func wallets(_ section: WalletsSection, settingsFor wallet: WalletNew) {
        let wallet = WalletSettingsViewController()
        wallet.modalPresentationStyle = .fullScreen
        
        present(wallet, animated: true)
    }
}

// MARK: - ScanDelegate

extension WalletViewController: ScanDelegate {
    func scan(_ controller: ScanViewController, didScan type: QRDetector.QRType) {
        switch type {
        case .transfer(let address):
            print(address)
//        case .tonConnect(let query):
//            let vc = TonConnectViewController(model: query)
//            present(vc, animated: true)
        
        default: break
        }
    }
}
