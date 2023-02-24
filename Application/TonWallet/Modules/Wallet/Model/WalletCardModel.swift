import IGListDiffKit

class WalletCardModel {
    let wallet: String
    
    init(wallet: String) {
        self.wallet = wallet
    }
}

extension WalletCardModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return wallet as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else { return false }
        
        return object.wallet == wallet
    }
}
