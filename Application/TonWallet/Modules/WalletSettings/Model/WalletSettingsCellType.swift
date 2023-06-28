import UIKit

enum WalletSettingsCellType {
    case address(active: String)
    case phrase
    
    var image: UIImage? {
        switch self {
        case .address: return R.image.walletSettingsAddress()?.withTintColor(R.color.textPrimary()!)
        case .phrase: return R.image.reload()?.withTintColor(R.color.textPrimary()!)
        }
    }
    
    var title: String {
        switch self {
        case .address: return localizable.walletSettingsActiveAddress()
        case .phrase: return localizable.walletSettingsRecovery()
        }
    }
    
    var rightType: SettingsType.CellType.RightViewType {
        switch self {
        case .address(let active): return .label(active)
        case .phrase: return .arrow
        }
    }
}

