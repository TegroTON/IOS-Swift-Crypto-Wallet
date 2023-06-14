import Moya
import Alamofire

enum AccountAPI {
    case account(id: String)
}

extension AccountAPI: TonWalletAPITargetType {
    var path: String {
        switch self {
        case .account(let id):
            return "accounts/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .account:
            return .get
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .account:
            return nil
        }
    }
}
