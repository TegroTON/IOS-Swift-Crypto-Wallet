import UIKit

class WalletSettingsViewController: UIViewController {
    
    private let wallet: Wallet
    private var dataSource: [WalletSettingsCellType] = []
    private var mnemonics: [String] = []
    
    private var mainView: WalletSettingsView { view as! WalletSettingsView }
    override func loadView() { view = WalletSettingsView() }

    init(wallet: Wallet) {
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
        
        mainView.setupWalletInfo(with: wallet)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
//        mainView.addTapGesture(target: self, action: #selector(viewTapped))
        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        DispatchQueue.global().async {
            self.mnemonics = KeychainManager().getMnemonics(id: self.wallet.id) ?? []
        }
    }
    
    // MARK: - Private actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func viewTapped() {
        mainView.walletNameView.textField.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = [.address(active: wallet.activeContract?.versionName ?? ""), .phrase]
    }
    
}

// MARK: - UITableViewDataSource

extension WalletSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.description(), for: indexPath) as! SettingsCell
        let type = dataSource[indexPath.row]
        
        cell.iconImageView.image = type.image
        cell.titleLabel.text = type.title
        cell.rightView.set(type: type.rightType)
        
        return cell
    }

}

// MARK: - UITableViewDelegate

extension WalletSettingsViewController  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("--- ALOHA")
        switch dataSource[indexPath.row] {
        case .address:
            break
            
        case .phrase:
            let mnemonics = SeedPhraseViewController(mnemonics: mnemonics)
            navigationController?.pushViewController(mnemonics, animated: true)
        }
    }
}

