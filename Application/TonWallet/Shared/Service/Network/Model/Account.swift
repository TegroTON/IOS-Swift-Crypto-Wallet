import Foundation

struct Account: Codable {
    let address: String
    let balance: Int
    let lastActivity: Int?
    let status: String
    let interfaces: [String]?
    let name: String?
    let isScam: Bool?
    let icon: String?
    let memoRequired: Bool?
    let getMethods: [String]?

    enum CodingKeys: String, CodingKey {
        case address, balance
        case lastActivity = "last_activity"
        case status, interfaces, name
        case isScam = "is_scam"
        case icon
        case memoRequired = "memo_required"
        case getMethods = "get_methods"
    }
}
