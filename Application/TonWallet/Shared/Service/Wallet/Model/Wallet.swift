import Foundation

@available(*, deprecated, message: "This method not use new models for wallets")
class Wallet: Codable, Equatable {
    let id: String
    var name: String = "Ton Wallet"
    
    var selectedAddress: WalletAddress?
    var addresses: [WalletAddress]?
    
    /// balance in selected address
    var balance: Double = 0
    
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

struct SavedWallet: Codable {
    let id: String
    let name: String
}

class WalletNew: Equatable {
    let id: String
    var name: String
    var nanoBalance: Double?
    var activeContract: ContractVersion?
    var contractVersions: [ContractVersion] = []
    
    var balance: Double? {
        if let nanoBalance {
            return nanoBalance / 1000000000
        }
        
        return nil
    }
    
    init(id: String, name: String, contractVersions: [ContractVersion]) {
        self.id = id
        self.name = name
        self.contractVersions = contractVersions
    }
    
    static func == (lhs: WalletNew, rhs: WalletNew) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ContractVersion {
    case v4r2(WalletV4R2)
    case v3r2(WalletV3)
    case v3r1(WalletV3)
    
    var contract: WalletContract {
        switch self {
        case .v4r2(let contract): return contract
        case .v3r2(let contract): return contract
        case .v3r1(let contract): return contract
        }
    }
}
