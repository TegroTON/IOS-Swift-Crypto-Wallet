import UIKit

protocol WalletAddressesDelegate: AnyObject {
    func walletAddresses(_ controller: WalletAddressesViewController, didSelect address: ContractVersion)
}

class WalletAddressesViewController: ModalScrollViewController {
        
    weak var delegate: WalletAddressesDelegate?
    
    private let wallet: Wallet

    private var mainView: WalletAddressesView { modalView as! WalletAddressesView }
    override func loadModalView() { modalView = WalletAddressesView() }
     
    init(wallet: Wallet) {
        self.wallet = wallet
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

// MARK: - UITableViewDataSource

extension WalletAddressesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet.contractVersions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletAddressCell.description(), for: indexPath) as! WalletAddressCell
        
        cell.addressLabel.text = nil
        cell.versionLabel.text = nil
        
        do {
            let version = wallet.contractVersions[indexPath.row].versionName
            let address = try wallet.contractVersions[indexPath.row].contract.address().toString()
            let currentAddress = try wallet.activeContract?.contract.address().toString() ?? ""
            
            print(wallet.contractVersions[indexPath.row])
            
            cell.addressLabel.text = address
            cell.versionLabel.text = version
            cell.separatorView.isHidden = indexPath.row == wallet.contractVersions.count - 1
            cell.checkMarkImageView.isHidden = address != currentAddress
        } catch {
            print(error.localizedDescription)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WalletAddressesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.walletAddresses(self, didSelect: wallet.contractVersions[indexPath.row])
    }
}
