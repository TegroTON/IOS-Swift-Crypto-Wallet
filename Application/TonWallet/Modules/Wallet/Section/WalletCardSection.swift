import IGListKit

protocol WalletCardsSectionDelegate: AnyObject {
    
}

class WalletCardsSection: ListSectionController {
    
    weak var delegate: WalletCardsSectionDelegate?
    
    var model: WalletCardsModel!
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        minimumLineSpacing = 16
    }
    
    override func didUpdate(to object: Any) {
        precondition(object is WalletCardsModel)
        model = object as? WalletCardsModel
    }
    
    override func numberOfItems() -> Int {
        return model.wallets.count
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(
            width: collectionContext!.containerSize.width - 24.0 - 24.0,
            height: collectionContext!.containerSize.height
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeue(of: WalletCardCell.self, for: self, at: index)
        let wallet = model.wallets[index]
        
        cell.cardView.nameLabel.text = wallet.name
        cell.cardView.addressLabel.text = wallet.selectedAddress?.address
        cell.cardView.balanceLabel.text = "???"
        
        return cell
    }
}
