import IGListDiffKit

class WalletsSectionModel {
    let wallet: String
    
    init(wallet: String) {
        self.wallet = wallet
    }
}

// MARK: - ListDiffable

extension WalletsSectionModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return wallet as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Self else { return false }
        
        return object.wallet == wallet
    }
}
