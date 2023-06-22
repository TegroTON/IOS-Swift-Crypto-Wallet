import UIKit

class SecurityViewController: ModalScrollViewController {
    
    private var dataSource: [[SecurityType]] = []
    
    private var mainView: SecurityView { modalView as! SecurityView }
    override func loadModalView() { modalView = SecurityView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
                
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = [
            [
                .biometry(type: .faceID)
            ], [
                .changePasscode,
                .resetPasscode
            ]
        ]
    }
    
    private func handleSelectCell(_ type: SecurityType) {
        switch type {
        default: break
        }
    }    
}

// MARK: - UITableViewDataSource

extension SecurityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.description(), for: indexPath) as! SettingsCell
        let type = dataSource[indexPath.section][indexPath.row]
        
        cell.iconImageView.image = type.image
        cell.titleLabel.text = type.title
        cell.rightView.set(type: type.rightType)
        cell.setSubtitle(type.subtitle)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SecurityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSelectCell(dataSource[indexPath.section][indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
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
        
        return 16.0 + 1.0 + 16.0
    }    
}
