import Foundation

struct SavedWallet: Codable {
    let id: String
    var name: String
    var versionName: String
}

class Wallet: Equatable {
    let id: String
    var name: String
    var nanoBalance: Double?
    var activeContract: ContractVersion!
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
    
    static func == (lhs: Wallet, rhs: Wallet) -> Bool {
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
    
    var versionName: String {
        switch self {
        case .v4r2: return "v4R2"
        case .v3r2: return "v3R2"
        case .v3r1: return "v3R1"
        }
    }
}
