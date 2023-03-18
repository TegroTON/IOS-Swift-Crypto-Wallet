import Foundation

class Wallet: Codable, Equatable {
    let id: String
    var name: String = "Wallet"
    var selectedAddress: WalletAddress?
    var addresses: [WalletAddress]?
    
    init(id: String) {
        self.id = id
    }
    
    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.id == rhs.id
    }
}

class WalletAddress: Codable {
    let name: String
    let address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
}
