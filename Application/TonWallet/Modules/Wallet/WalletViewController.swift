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
        return [WalletsSectionModel(wallet: "wallets")]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is WalletsSectionModel:
            return WalletsSection()
            
        default:
            preconditionFailure("Unknown object type")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}
