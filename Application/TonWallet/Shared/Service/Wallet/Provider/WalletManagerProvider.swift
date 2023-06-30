import Moya

protocol WalletManagerProviderDelegate: AnyObject {
    func walletManager(_ provider: WalletManagerProvider, didLoad account: Account)
    func walletManager(_ provider: WalletManagerProvider, didFailLoadAccount error: Error)
}

class WalletManagerProvider {
    
    weak var delegate: WalletManagerProviderDelegate?
    
    func loadAccount(address: String, completion: ((Result<Account, Error>) -> Void)? = nil) {
        let target = AccountAPI.account(id: address)
        
        MoyaProvider().request(target) { [weak self] result in
            do {
                let response = try result.get()
                let account = try response.decode(Account.self)
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    self.delegate?.walletManager(self, didLoad: account)
                    completion?(.success(account))
                }
            } catch {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    self.delegate?.walletManager(self, didFailLoadAccount: error)
                    completion?(.failure(error))
                }
            }
        }
    }
    
}
