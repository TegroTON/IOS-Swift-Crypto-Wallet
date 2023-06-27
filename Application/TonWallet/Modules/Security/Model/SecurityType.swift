import UIKit

enum SecurityType {
    case biometry(type: BiometryType, isOn: Bool)
    case changePasscode
    case resetPasscode
    
    var image: UIImage? {
        switch self {
        case .biometry(let type, _):
            switch type {
            case .faceID: return UIImage(systemName: "faceid")?.withTintColor(R.color.textPrimary()!)
            case .touchID: return UIImage(systemName: "touchid")?.withTintColor(R.color.textPrimary()!)
            }
        case .changePasscode: return R.image.securityChange()?.withTintColor(R.color.textPrimary()!)
        case .resetPasscode: return R.image.securityReset()?.withTintColor(R.color.textPrimary()!)
        }
    }
    
    var title: String {
        switch self {
        case .biometry(let type, _):
            switch type {
            case .faceID: return localizable.securityFaceId()
            case .touchID: return localizable.securityTouchId()
            }
        case .changePasscode: return localizable.securityChange()
        case .resetPasscode: return localizable.securityReset()
        }
    }
    
    var subtitle: String? {
        switch self {
        case .biometry: return localizable.securityBiometrySubtitle()
        default: return nil
        }
    }
    
    var rightType: SettingsType.CellType.RightViewType {
        switch self {
        case .biometry(_, let isON): return .switch(isON)
        case .changePasscode: return .arrow
        case .resetPasscode: return .arrow
        }
    }
    
    enum BiometryType {
        case faceID
        case touchID
    }
}

