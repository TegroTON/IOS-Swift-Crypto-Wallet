import IGListKit

class WalletCardSection: ListSectionController {
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        minimumLineSpacing = 16
    }
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(
            width: collectionContext!.containerSize.width - 24.0 - 24.0,
            height: collectionContext!.containerSize.height
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: WalletCardCell.self, for: self, at: index)
        
        return cell
    }
}
