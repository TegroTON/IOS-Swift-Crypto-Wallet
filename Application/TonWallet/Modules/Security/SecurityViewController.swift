import UIKit
import LocalAuthentication

class SecurityViewController: ModalScrollViewController {
    
    private var dataSource: [[SecurityType]] = []
    private var biometryType: SecurityType.BiometryType = .faceID
    
    private var mainView: SecurityView { modalView as! SecurityView }
    override func loadModalView() { modalView = SecurityView() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkBiometricType()
        setupDataSource()
                
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // MARK: - Private actions
    
    @objc private func handleSwitcher(_ sender: UISwitch) {
        UserSettings.shared.biometryEnabled = sender.isOn
        dataSource[0][0] = .biometry(type: biometryType, isOn: sender.isOn)
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = [
            [
                .biometry(type: biometryType, isOn: UserSettings.shared.biometryEnabled)
            ], [
                .changePasscode,
                .resetPasscode
            ]
        ]
    }
    
    private func checkBiometricType() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID: biometryType = .faceID
            case .touchID: biometryType = .touchID
                
            case .none: break
            @unknown default: break
            }
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
        
        switch type.rightType {
        case .switch:
            cell.rightView.switcher.addTarget(self, action: #selector(handleSwitcher), for: .valueChanged)
        default: break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SecurityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch dataSource[indexPath.section][indexPath.row] {
        case .biometry(_, let isOn):
            let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
            cell.rightView.switcher.setOn(!isOn, animated: true)
            UserSettings.shared.biometryEnabled = !isOn
            dataSource[indexPath.section][indexPath.row] = .biometry(type: biometryType, isOn: !isOn)
            
        default: break
        }
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
