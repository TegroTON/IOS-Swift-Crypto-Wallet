import Foundation

struct ConnectRequest {
    let manifestUrl: String
    let items: [ConnectItem]
}

struct ConnectItem {
    let name: String
    let payload: String?
}
