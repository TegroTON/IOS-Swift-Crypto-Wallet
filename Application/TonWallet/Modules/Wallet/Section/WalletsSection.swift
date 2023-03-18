import IGListKit

protocol WalletsSectionDelegate: AnyObject {
    
}

class WalletsSection: ListSectionController {
       
    weak var delegate: WalletsSectionDelegate?
    
    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController)
    
    var model: WalletsSectionModel!
    
    override func didUpdate(to object: Any) {
        precondition(object is WalletsSectionModel)
        model = object as? WalletsSectionModel
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 224.0)
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: WalletsCell.self, for: self, at: index)
        
        adapter.collectionView = cell.collectionView
        adapter.dataSource = self
        
        return cell
    }
    
}

// MARK: - ListAdapterDataSource

extension WalletsSection: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            WalletCardsModel(wallets: model.wallets)
        ]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = WalletCardsSection()
        section.delegate = self
        
        return section
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - WalletCardsSectionDelegate

extension WalletsSection: WalletCardsSectionDelegate {
    
}
