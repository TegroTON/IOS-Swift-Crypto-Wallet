import Moya
import Alamofire

enum WalletAPI {
    case wallet(boc: String)
    case estimate(boc: String)
    case getSeqno(address: String)
}

extension WalletAPI: TonWalletAPITargetType {
    var baseURL: URL {
        switch self {
        case .wallet:
            return URL(string: "https://tonapi.io/v2/")!
            
        case .estimate, .getSeqno:
            return URL(string: "https://keeper.tonapi.io/v1/")!
        }
    }
    
    var path: String {
        switch self {
        case .wallet:
            return "wallet/emulate"
            
        case .estimate:
            return "send/estimateTx"
            
        case .getSeqno:
            return "wallet/getSeqno"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .wallet, .estimate:
            return .post
            
        case .getSeqno:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .wallet:
            return [
                "Accept-Language": "ru-RU,ru;q=0.5",
                "Content-Type": "application/json",
                "Authorization": "Bearer AF77F5JNEUSNXPQAAAAMDXXG7RBQ3IRP6PC2HTHL4KYRWMZYOUQGDEKYFDKBETZ6FDVZJBI"
            ]
            
        case .estimate, .getSeqno:
            return [
                "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOlsiMjoyIl0sImp0aSI6IlY0NEIzVFdCM01CUlo3SVciLCJzY29wZSI6ImNsaWVudCIsInN1YiI6InRvbmFwaSJ9.Eh7gz33WRgoaCtZHmQDqJxcD4pJvTGQovEYRqKkN2TshLckcQ_k4btDQQXTURFcRKZkZJSc0MH9tqwuwHPrEvUYKhLxQ9gKLpnDzDsBVmnRG-nJ2yOyqqCeY83EaxrIDDwbmf3vSQP9SaqsMtNUzVTLtsn_RZ41wP594e6uuBXZJPV9g4auHMHj12wvMSL4_vBoEVCrZXP6qktCtUDpqnsBkT9T2iSd61DIC8tOePjrrR3WPqj4qX3w6obCGnc20ZkCHX_yf3XhGWftub7y4zqJ5NWbVcFI4eNdYN5yEEr_9s8v3VCoZqBKF2gUJT2zf7NA5NvYWwX1_EfzC0F3udQ"
            ]
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .wallet(let boc):
            return ["boc": boc]
            
        case .estimate(let boc):
            return ["boc": boc]
            
        case .getSeqno(let address):
            return ["account": address]
        }
    }
}
