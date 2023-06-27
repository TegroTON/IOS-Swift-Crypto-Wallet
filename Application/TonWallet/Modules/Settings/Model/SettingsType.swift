import UIKit

enum SettingsType {
    case cell(type: CellType)
    case logoutButton
    
    enum CellType {
        case wallets(count: Int)
        case tokens(count: Int)
        case contacts
        case security
        case appearance(current: AppearanceType)
        case currency(current: String)
        case language(current: LanguageType)
        case search(current: SearchType)
        case notifications(isOn: Bool)
        case contactUs
        case helpCenter
        case rate
        case deleteAccount
        
        var image: UIImage? {
            switch self {
            case .wallets:       return R.image.settingsWallets()
            case .tokens:        return R.image.settingsTokens()
            case .contacts:      return R.image.settingsContacts()
            case .security:      return R.image.settingsSecurity()
            case .appearance:    return R.image.settingsAppearance()
            case .currency:      return R.image.settingsCurrency()
            case .language:      return R.image.settingsLanguage()
            case .search:        return R.image.settingsSearch()
            case .notifications: return R.image.settingsNotification()
            case .contactUs:     return R.image.settingsContactUs()
            case .helpCenter:    return R.image.settingsHelpCenter()
            case .rate:          return R.image.settingsRate()
            case .deleteAccount: return R.image.settingsDelete()?.withTintColor(R.color.textPrimary()!)
            }
        }
        
        var title: String {
            switch self {
            case .wallets:       return localizable.settingsWallets()
            case .tokens:        return localizable.settingsTokens()
            case .contacts:      return localizable.settingsContacts()
            case .security:      return localizable.settingsSecurity()
            case .appearance:    return localizable.settingsAppearance()
            case .currency:      return localizable.settingsCurrency()
            case .language:      return localizable.settingsLanguage()
            case .search:        return localizable.settingsSearch()
            case .notifications: return localizable.settingsNotifications()
            case .contactUs:     return localizable.settingsContactUs()
            case .helpCenter:    return localizable.settingsHelpCenter()
            case .rate:          return localizable.settingsRateApp()
            case .deleteAccount: return localizable.settingsDelete()
            }
        }
        
        var subtitle: String? {
            switch self {
            case .notifications:
                return localizable.settingsNotificationsSubtitle()
                
            default:
                return nil
            }
        }
        
        var rightType: RightViewType {
            switch self {
            case .wallets(let badge):       return .badge(badge)
            case .tokens(let badge):        return .badge(badge)
            case .contacts:                 return .arrow
            case .security:                 return .arrow
            case .appearance(let current):  return .label(current.title)
            case .currency(let current):    return .label(current)
            case .language(let current):    return .label(current.title)
            case .search(let current):      return .label(current.rawValue)
            case .notifications(let isOn):  return .switch(isOn)
            case .contactUs:                return .arrow
            case .helpCenter:               return .arrow
            case .rate:                     return .arrow
            case .deleteAccount:            return .arrow
            }
        }
        
        enum RightViewType {
            case badge(Int)
            case label(String)
            case `switch`(Bool)
            case arrow
        }
        
        enum AppearanceType: String {
            case auto
            case dark
            case light
            
            var title: String {
                return rawValue.capitalized
            }
        }
        
        enum LanguageType: String {
            case eng
            
            var title: String {
                return rawValue.capitalized
            }
        }
        
        enum SearchType: String {
            case google = "Google"
        }
    }

}
