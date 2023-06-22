import UIKit

enum SecurityType {
    case biometry(type: BiometryType)
    case changePasscode
    case resetPasscode
    
    var image: UIImage? {
        switch self {
        case .biometry(let type):
            switch type {
            case .faceID: return UIImage(systemName: "faceid")
            case .touchID: return UIImage(systemName: "touchid")
            }
        case .changePasscode: return R.image.securityChange()
        case .resetPasscode: return R.image.securityReset()
        }
    }
    
    var title: String {
        switch self {
        case .biometry(let type):
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
        case .biometry: return .switch
        case .changePasscode: return .arrow
        case .resetPasscode: return .arrow
        }
    }
    
    enum BiometryType {
        case faceID
        case touchID
    }
}

