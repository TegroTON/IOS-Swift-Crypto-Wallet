import Foundation

class Wallet: Codable {
    let id: String
    var name: String = "Wallet"
    
    init(id: String) {
        self.id = id
    }
}
