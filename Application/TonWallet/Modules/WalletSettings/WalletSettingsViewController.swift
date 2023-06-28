import UIKit

class WalletSettingsViewController: UIViewController {
    
    private var dataSource: [WalletSettingsCellType] = []
    
    private var mainView: WalletSettingsView { view as! WalletSettingsView }
    override func loadView() { view = WalletSettingsView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
        mainView.addTapGesture(target: self, action: #selector(viewTapped))
        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
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
        dataSource = [.address(active: "v3R2"), .phrase]
    }
    
}

// MARK: - UITableViewDataSource

extension WalletSettingsViewController: UITableViewDataSource {
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

extension WalletSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch dataSource[indexPath.row] {
        case .address:
            break
            
        case .phrase:
            break
            
        default: break
        }
    }
}

