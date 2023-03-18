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
    
    /// create new wallet and save to user defaults app
    /// - Parameter mnemonics: generated unique mnemonics
    /// - Returns: created wallet
    @discardableResult
    func create(wallet mnemonics: [String]) -> Wallet {
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
    
    
    /// delete wallet from user defaults app
    /// - Parameter id: wallet id
    func delete(wallet id: String) {
        let index = wallets.firstIndex(where: { $0.id == id })!
        wallets.remove(at: index)
        saveWallets()
    }
    
    
    /// set new name for wallet
    /// - Parameters:
    ///   - name: new wallet name
    ///   - id: wallet id
    func set(name: String, for id: String) {
        if let wallet = wallets.first(where: { $0.id == id }) {
            wallet.name = name
        }
    }
    
    
    /// set calculated keys from wallet mnemonics and generate addreses for wallet
    /// - Parameters:
    ///   - keys: key pair (private and public keys)
    ///   - id: wallet id
    func set(keys: TonKeyPair, for id: String) {
        if let wallet = wallets.first(where: { $0.id == id }) {
            let addresses = getAddresses(publicKey: keys.publicKey)
            wallet.selectedAddress = addresses.first
            wallet.addresses = addresses
            
            saveWallets()
        }
        
        keychein.storeKeys(id: id, keyPair: keys) { success in
            if success {
                print("💙 success store keys")
            } else {
                print("❤️ failure store keys")
            }
        }
    }
    
    /// select address for wallet like main address, this will be displayed on the home screen
    /// - Parameters:
    ///   - address: the address of one of the wallet contracts, if this address is not in any of the contracts, it will not be selected
    ///   - id: wallet id
    func select(address: WalletAddress, for id: String) {
        if let wallet  = wallets.first(where: { $0.id == id }) {
            if wallet.addresses?.contains(where: { $0.address == address.address }) == true {
                wallet.selectedAddress = address
                saveWallets()
            }
        }
    }
    
    // MARK: - Private methods
    
    /// generating unique id for wallet
    /// - Returns: wallet id in uuid type
    private func generateUniqueID() -> String {
        var id = UUID().uuidString
        while wallets.contains(where: { $0.id == id }) {
            id = UUID().uuidString
        }
        
        return id
    }
    
    /// save or update wallets
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
    
    private func getAddresses(publicKey: String) -> [WalletAddress] {
        let v4r2 = TonManager.shared.getAddress(.v4r2, publicKey: publicKey)
        return [v4r2]
    }
    
}
