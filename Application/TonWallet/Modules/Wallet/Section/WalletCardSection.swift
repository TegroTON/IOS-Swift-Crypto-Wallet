import IGListKit

protocol WalletCardsSectionDelegate: AnyObject {
    func walletCards(_ section: WalletCardsSection, sendFrom wallet: Wallet)
    func walletsCards(_ section: WalletCardsSection, receiveTo wallet: Wallet)
    func walletsCards(_ section: WalletCardsSection, settingsFor wallet: Wallet)
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
        cell.cardView.addressLabel.text = try? wallet.activeContract?.contract.address().toFriendly().toString()
        cell.cardView.balanceLabel.text = String(format: "%.1g", wallet.balance ?? 0.0) + " TON"
        
        cell.cardView.sendButton.tag = index
        cell.cardView.receiveButton.tag = index
        cell.cardView.settingsButton.tag = index
        
        cell.cardView.sendButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.cardView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        cell.cardView.receiveButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.cardView.receiveButton.addTarget(self, action: #selector(receiveButtonTapped), for: .touchUpInside)
        
        cell.cardView.settingsButton.removeTarget(nil, action: nil, for: .touchUpInside)
        cell.cardView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func sendButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let wallet = model.wallets[index]
        
        delegate?.walletCards(self, sendFrom: wallet)
    }
    
    @objc private func receiveButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let wallet = model.wallets[index]
        
        delegate?.walletsCards(self, receiveTo: wallet)
    }
    
    @objc private func settingsButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let wallet = model.wallets[index]
        
        delegate?.walletsCards(self, settingsFor: wallet)
    }
}
