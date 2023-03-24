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
    func wallets(_ section: WalletsSection, sendFrom wallet: Wallet) {
        let navVC = RootNavigationController(rootViewController: SendViewController())
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        
        present(navVC, animated: true)
    }
    
    func wallets(_ section: WalletsSection, receiveTo wallet: Wallet) {
        let vc = ReceiveViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        present(vc, animated: true)
    }
}
