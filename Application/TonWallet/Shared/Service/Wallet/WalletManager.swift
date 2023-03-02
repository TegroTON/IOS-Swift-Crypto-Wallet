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
        keychein.storeMnemonics(mnemonics, id: newWallet.id) { success in
            if success {
                print("💙 success store mnemonics")
            } else {
                print("❤️ failure store mnemonics")
            }
        }
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
        keychein.storeKeys(id: id, keyPair: keys) { success in
            if success {
                print("💙 success store keys")
            } else {
                print("❤️ failure store keys")
            }
        }
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
