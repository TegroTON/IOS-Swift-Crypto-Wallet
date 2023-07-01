import Foundation

class WalletManager {

    static let shared = WalletManager()
    
    private(set) var wallets: [Wallet] = []
    private(set) var currentWallet: Wallet?
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
                self.loadBalances()
                
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadBalances() {
        walletQueue.async {
            for wallet in self.wallets {
                self.updateBalance(for: wallet)
            }
        }
    }
    
    func updateBalance(for wallet: Wallet, completion: (() -> (Void))? = nil) {
        walletQueue.async {
            do {
                let address = try wallet.activeContract?.contract.address().toRaw() ?? ""
                
                self.provider.loadAccount(address: address) { result in
                    switch result {
                    case .success(let account):
                        wallet.nanoBalance = Double(account.balance)
                        print("💙 account: \(account)")
                        completion?()
                        
                    case .failure(let error):
                        print("❤️ error load account: \(error.localizedDescription)")
                        completion?()
                    }
                }
            } catch {
                print("❤️ error get address: \(error.localizedDescription)")
                completion?()
            }
        }
    }
    
    func select(active contract: ContractVersion, for wallet: Wallet) {
        if let index = wallets.firstIndex(of: wallet) {
            wallets[index].activeContract = contract
            
            walletQueue.async {
                if let index = self.userSettings.wallets.firstIndex(where: { $0.id == wallet.id }) {
                    self.userSettings.wallets[index].versionName = contract.versionName
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
            
            if let contract = wallet.contractVersions.first(where: { $0.versionName == savedWallet.versionName }) {
                wallet.activeContract = contract
            }
            
            wallets.append(wallet)
        }
        
        currentWallet = wallets.first
        loadBalances()
    }
    
    private func createWallet(id: String, name: String, mnemonics: [String]) throws -> Wallet {
        let keyPair = try Mnemonic.mnemonicToPrivateKey(mnemonicArray: mnemonics)
        
        let contracts: [ContractVersion] = [
            .v4r2(WalletV4R2(publicKey: keyPair.publicKey)),
            .v3r2(try WalletV3(workchain: 0, publicKey: keyPair.publicKey, revision: .r2)),
            .v3r1(try WalletV3(workchain: 0, publicKey: keyPair.publicKey, revision: .r1))
        ]
        
        let wallet = Wallet(id: id, name: name, contractVersions: contracts)
        wallet.activeContract = contracts[0]
        
        return wallet
    }
    
}
