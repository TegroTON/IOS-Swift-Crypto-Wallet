import IGListDiffKit

class WalletCardsModel {
    let wallets: [WalletNew]
    
    init(wallets: [WalletNew]) {
        self.wallets = wallets
    }
}

extension WalletCardsModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return wallets as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else { return false }
        
        return object.wallets == wallets
    }
}
