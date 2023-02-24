import Foundation

class WalletManager {
    static let shared = WalletManager()
    
    private(set) var wallets: [Wallet] = []
    private let walletQueue: DispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).wallet")
    private let keychein = KeychainManager()

    init() {
        do {
            guard let data = UserSettings.wallets else { return }
            wallets = try JSONDecoder().decode([Wallet].self, from: data)
        } catch {
            print("❤️ Faild decode wallets in init(), error:", error)
        }
    }
    
    // MARK: - Public methods
    
    @discardableResult
    func createWallet(mnemonics: [String]) -> Wallet {
        let newWallet = Wallet(id: generateUniqueID())
        wallets.append(newWallet)
        keychein.storeMnemonics(mnemonics, id: newWallet.id)
        saveWallets()
        
        return newWallet
    }
    
    func deleteWallet(id: String) {
        let index = wallets.firstIndex(where: { $0.id == id })!
        wallets.remove(at: index)
        saveWallets()
    }
    
    func setName(_ name: String, for id: String) {
        if let wallet = wallets.first(where: { $0.id == id }) {
            wallet.name = name
        }
    }
    
    func setKeys(_ keys: TonKeyPair, for id: String) {
        keychein.storeKeys(id: id, publicKey: keys.publicKey, privateKey: keys.privateKey)
    }
    
    // MARK: - Private methods
    
    private func generateUniqueID() -> String {
        var id = UUID().uuidString
        while wallets.contains(where: { $0.id == id }) {
            id = UUID().uuidString
        }
        
        return id
    }
    
    private func saveWallets() {
        walletQueue.async {
            do {
                let data = try JSONEncoder().encode(self.wallets)
                UserSettings.wallets = data
            } catch {
                print("❤️ Faild encode users in saveWallets(), error:",  error)
            }
        }
    }
}
