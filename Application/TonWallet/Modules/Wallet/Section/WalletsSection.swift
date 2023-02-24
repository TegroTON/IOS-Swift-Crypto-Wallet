import IGListKit

class WalletsSection: ListSectionController {
       
    lazy var adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController)
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let size = CGSize(width: collectionContext!.containerSize.width, height: 224.0)
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: WalletsCell.self, for: self, at: index)
        
        return configure(cell: cell)
    }
    
    @discardableResult
    private func configure(cell: WalletsCell) -> WalletsCell {
        adapter.collectionView = cell.collectionView
        adapter.dataSource = self
        
        return cell
    }
}

extension WalletsSection: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [WalletCardModel(wallet: "WalletCardModel")]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let section = WalletCardSection()
        
        return section
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
