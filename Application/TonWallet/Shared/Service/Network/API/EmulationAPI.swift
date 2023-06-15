import Moya
import Alamofire

enum EmulationAPI {
    case wallet(boc: String)
}

extension EmulationAPI: TonWalletAPITargetType {
    var path: String {
        switch self {
        case .wallet:
            return "wallet/emulate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .wallet:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .wallet:
            return [
                "Accept-Language": "ru-RU,ru;q=0.5",
                "Content-Type": "application/json"
            ]
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .wallet(let boc):
            return ["boc": boc]
        }
    }
}
