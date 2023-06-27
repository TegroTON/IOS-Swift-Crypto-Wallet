import UIKit
import SafariServices

class SettingsViewController: UIViewController {

    var mainView: SettingsView {
        return view as! SettingsView
    }
    
    private var dataSource: [[SettingsType]] = []
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
                
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // MARK: - Private actions
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(
            title: localizable.settingsLogoutAlertTitle(),
            message: localizable.settingsLogoutAlertMessage(),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: localizable.settingsLogoutAlertCancel(), style: .cancel)
        let logoutAction = UIAlertAction(title: localizable.settingsLogout(), style: .destructive) { _ in
            UserSettings.shared.logout()
            
            for wallet in WalletManager.shared.wallets {
                KeychainManager().deleteMnemonics(for: wallet.id)
                KeychainManager().deleteKeys(for: wallet.id)
            }
            KeychainManager().deletePassword()
            
            RootNavigationController.shared.setViewControllers([CreateViewController()], animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = [
            [
                .cell(type: .wallets(count: 1)),
                .cell(type: .security)
            ], [
                .cell(type: .contactUs),
                .cell(type: .deleteAccount)
            ], [
                .logoutButton
            ]
        ]
    }
    
    private func handleSelectCell(_ type: SettingsType.CellType) {
        switch type {
        case .wallets: openMyWallets()
        case .security: openSecurity()
        case .contactUs: openTelegram()
        case .deleteAccount: deleteAccount()
            
        default: break
        }
    }
    
    private func openMyWallets() {
        
    }
    
    private func openSecurity() {
        let vc = SecurityViewController()
        present(vc, animated: true)
    }
    
    private func openTelegram() {
        let vc = SFSafariViewController(url: URL(string: "https://t.me/TegroForum")!)
        present(vc, animated: true)
    }
    
    private func deleteAccount() {
        let alert = UIAlertController(
            title: localizable.settingsDeleteAlertTitle(),
            message: localizable.settingsDeleteAlertMessage(),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: localizable.settingsLogoutAlertCancel(), style: .cancel)
        let logoutAction = UIAlertAction(title: localizable.settingsDeleteAlertOk(), style: .destructive) { _ in
            UserSettings.shared.logout()
            
            for wallet in WalletManager.shared.wallets {
                KeychainManager().deleteMnemonics(for: wallet.id)
                KeychainManager().deleteKeys(for: wallet.id)
            }
            KeychainManager().deletePassword()
            
            RootNavigationController.shared.setViewControllers([CreateViewController()], animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsType = dataSource[indexPath.section][indexPath.row]
        
        switch settingsType {
        case .cell(let cellType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.description(), for: indexPath) as! SettingsCell

            cell.iconImageView.image = cellType.image
            cell.titleLabel.text = cellType.title
            cell.rightView.set(type: cellType.rightType)
            cell.setSubtitle(cellType.subtitle)

            return cell

        case .logoutButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsButtonCell.description(), for: indexPath) as! SettingsButtonCell
            cell.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch dataSource[indexPath.section][indexPath.row] {
        case .cell(let type): handleSelectCell(type)
        case .logoutButton: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        if section == dataSource.count - 1 {
            return nil
        }
        
        return SettingsSeparatorView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        if section == dataSource.count - 1 {
            return 0.0
        }
        
        return 16.0 + 1.0 + 16.0
    }
}
