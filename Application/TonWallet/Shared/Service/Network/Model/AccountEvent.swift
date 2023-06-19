import Foundation

struct AccountEvent: Codable {
    let eventId: String?
    let account: AccountAddress?
    let timestamp: Int?
    let actions: [Action]?
    let fee: Fee?
    let valueFlow: ValueFlow?
    let isScam: Bool?
    let lt: Int?
    let inProgress: Bool?
}

struct AccountAddress: Codable {
    let address: String?
    let name: String?
    let isScam: Bool?
    let icon: String?
}

struct Action: Codable {
    let type: ActionTypeEnum?
    let status: ActionStatusEnum?
    let tonTransfer: TonTransferAction?
    let jettonTransfer: JettonTransferAction?
    let simplePreview: ActionSimplePreview?
    
    enum CodingKeys: String, CodingKey {
        case type
        case status
        case tonTransfer = "TonTransfer"
        case jettonTransfer = "JettonTransfer"
        case simplePreview
    }
}

enum ActionTypeEnum: String, Codable {
    case tonTransfer = "TonTransfer"
    case jettonTransfer = "JettonTransfer"
    case nftItemTransfer = "NftItemTransfer"
    case contractDeploy = "ContractDeploy"
    case subscribe = "Subscribe"
    case unSubscribe = "UnSubscribe"
    case auctionBid = "AuctionBid"
    case nftPurchase = "NftPurchase"
    case smartContractExec = "SmartContractExec"
    case unknown = "Unknown"
}

enum ActionStatusEnum: String, Codable {
    case ok = "ok"
    case failed = "failed"
    case pending = "pending"
}

struct TonTransferAction: Codable {
    let sender: AccountAddress?
    let recipient: AccountAddress?
    let amount: Int?
    let comment: String?
    let refund: Refund?
}

struct Refund: Codable {
    let type: RefundTypeEnum?
    let origin: String?
}

enum RefundTypeEnum: String, Codable {
    case DnsTon = "DNS.ton"
    case DnsTg = "DNS.tg"
    case GetGems = "GetGems"
}

struct JettonTransferAction: Codable {
    let sender: AccountAddress?
    let recipient: AccountAddress?
    let sendersWallet: String?
    let recipientsWallet: String?
    let amount: String?
    let comment: String?
    let refund: Refund?
    let jetton: JettonPreview?
}

struct JettonPreview: Codable {
    let address: String?
    let name: String?
    let symbol: String?
    let decimals: Int?
    let image: String?
    let verification: JettonVerificationType?
}

enum JettonVerificationType: String, Codable {
    case whitelist
    case blacklist
    case none
}

struct ActionSimplePreview: Codable {
    let fullDescription: String?
    let name: String?
    let shortDescription: String?
}

struct Fee: Codable {
    let account: AccountAddress?
    let deposit: Int?
    let gas: Int?
    let refund: Int?
    let rent: Int?
    let total: Int?
}

struct ValueFlow: Codable {
    let account: AccountAddress?
    let ton: Int?
    let fees: Int?
    let nfts: ValueFlowNftsInner
    let jettons: ValueFlowNftsInner
}

struct ValueFlowNftsInner: Codable {
    let account: AccountAddress
    let quantity: Int
}
