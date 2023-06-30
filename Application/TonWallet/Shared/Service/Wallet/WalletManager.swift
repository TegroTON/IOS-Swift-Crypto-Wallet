import Foundation

class WalletManager {

    static let shared = WalletManager()
    
    private(set) var wallets: [WalletNew] = []
    private(set) var currentWallet: WalletNew?
    private let walletQueue: DispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).wallet")
    private let keychein = KeychainManager()
    private let userSettings = UserSettings.shared
    private let provider: WalletManagerProvider = .init()
    
    // MARK: - Public methods
    
    func initialize() {
        loadWallets()
    }
    
    func createNewWallet(mnemonics: [String] = [], completion: @escaping (Result<CreatedWallet, Error>) -> Void) {
        walletQueue.async {
            do {
                let mnemonics = mnemonics.isEmpty ? Mnemonic.mnemonicNew() : mnemonics
                let id = self.generateUniqueID()
                let wallet = try self.createWallet(id: id, name: "Ton Wallet", mnemonics: mnemonics)
                let result = CreatedWallet(mnemonics: mnemonics, wallet: wallet)
                
                self.wallets.append(wallet)
                self.currentWallet = wallet
                self.loadAccounts()
                
                completion(.success(result))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
    /// delete wallet from user defaults app
    /// - Parameter id: wallet id
    @available(*, deprecated, message: "This method not use TonSwift")
    func delete(wallet id: String) {
        let index = wallets.firstIndex(where: { $0.id == id })!
        wallets.remove(at: index)
        saveWallets()
    }
    
    /// set new name for wallet
    /// - Parameters:
    ///   - name: new wallet name
    ///   - id: wallet id
    @available(*, deprecated, message: "This method not use TonSwift")
    func set(name: String, for id: String) {
        if let wallet = wallets.first(where: { $0.id == id }) {
            
        }
    }
    
    /// select address for wallet like main address, this will be displayed on the home screen
    /// - Parameters:
    ///   - address: the address of one of the wallet contracts, if this address is not in any of the contracts, it will not be selected
    ///   - id: wallet id
    @available(*, deprecated, message: "This method not use TonSwift")
    func select(address: WalletAddress, for id: String) {
        if let wallet  = wallets.first(where: { $0.id == id }) {
           
        }
    }
    
    func loadAccounts() {
        walletQueue.async {
            for wallet in self.wallets {
                do {
                    let address = try wallet.activeContract?.contract.address().toRaw() ?? ""
                    
                    self.provider.loadAccount(address: address) { result in
                        switch result {
                        case .success(let account):
                            wallet.nanoBalance = Double(account.balance)
                            print("💙 account: \(account)")
                            
                        case .failure(let error):
                            print("❤️ error load account: \(error.localizedDescription)")
                        }
                    }
                } catch {
                    print("❤️ error get address: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    /// generating unique id for wallet
    /// - Returns: wallet id in uuid type
    private func generateUniqueID() -> String {
        let ids = userSettings.wallets.map { $0.id }
        var id = UUID().uuidString
        
        while ids.contains(where: { $0 == id }) {
            id = UUID().uuidString
        }
        
        return id
    }
    
    private func loadWallets() {
        for savedWallet in userSettings.wallets {
            guard
                let mnemonics = KeychainManager().getMnemonics(id: savedWallet.id),
                let wallet = try? createWallet(id: savedWallet.id, name: savedWallet.name, mnemonics: mnemonics)
            else { continue }
            
            wallets.append(wallet)
        }
        
        currentWallet = wallets.first
        loadAccounts()
    }
    
    private func createWallet(id: String, name: String, mnemonics: [String]) throws -> WalletNew {
        let keyPair = try Mnemonic.mnemonicToPrivateKey(mnemonicArray: mnemonics)
        
        let contracts: [ContractVersion] = [
            .v4r2(WalletV4R2(publicKey: keyPair.publicKey)),
            .v3r2(try WalletV3(workchain: 0, publicKey: keyPair.publicKey, revision: .r2)),
            .v3r2(try WalletV3(workchain: 0, publicKey: keyPair.publicKey, revision: .r1))
        ]
        
        let wallet = WalletNew(id: id, name: name, contractVersions: contracts)
        wallet.activeContract = contracts[0]
        
        return wallet
    }
    
    /// save or update wallets
    @available(*, deprecated, message: "This method not use TonSwift")
    private func saveWallets() {
        walletQueue.async {
            
        }
    }
    
    @available(*, deprecated, message: "This method not use TonSwift")
    private func getAddresses(publicKey: String) -> [WalletAddress] {
        let v4r2 = TonManager.shared.getAddress(.v4r2, publicKey: publicKey)
        return [v4r2]
    }
    
}
