import Moya

protocol TonWalletAPITargetType: TargetType {
    var parameters: [String: Any]? { get }
}

extension TonWalletAPITargetType {

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var baseURL: URL {
        return URL(string: "https://tonapi.io/v2/")!
    }

    var task: Task {
        guard let parameters = parameters else {
            return .requestPlain
        }

        let encoding: ParameterEncoding = {
            switch method {
            case .post, .put:
                return JSONEncoding.default
            default:
                return URLEncoding(destination: .queryString)
            }
        }()

        return .requestParameters(parameters: parameters, encoding: encoding)
    }

}
