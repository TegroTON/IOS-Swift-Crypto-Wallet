import UIKit

class SettingsViewController: UIViewController {

    var mainView: SettingsView {
        return view as! SettingsView
    }
    
    private var dataSource: [[SettingsModel]] = []
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataSource()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // MARK: - Private methods
    
    private func setupDataSource() {
        dataSource = [[
            SettingsModel(
                type: .cell(
                    image: R.image.wallet(),
                    title: R.string.localizable.settingsWallets(),
                    rightType: .badge(1)
                )
            ),
            SettingsModel(
                type: .cell(
                    image: R.image.fingerprint(),
                    title: R.string.localizable.settingsSecurity(),
                    rightType: .arrow
                )
            )
        ], [
            SettingsModel(
                type: .cell(
                    image: R.image.sunny(),
                    title: R.string.localizable.settingsAppearance(),
                    rightType: .label("Auto")
                )
            ),
            SettingsModel(
                type: .cell(
                    image: R.image.earth(),
                    title: R.string.localizable.settingsLanguage(),
                    rightType: .label("Eng")
                )
            ),
            SettingsModel(
                type: .cell(
                    image: R.image.notificationBell(),
                    title: R.string.localizable.settingsNotifications(),
                    subtitle: R.string.localizable.settingsNotificationsSubtitle(),
                    rightType: .switch
                )
            ),
        ], [
            SettingsModel(
                type: .cell(
                    image: R.image.email(),
                    title: R.string.localizable.settingsContactUs(),
                    rightType: .arrow
                )
            ),
            SettingsModel(
                type: .cell(
                    image: R.image.document(),
                    title: R.string.localizable.settingsHelpCenter(),
                    rightType: .arrow
                )
            ),
            SettingsModel(
                type: .cell(
                    image: R.image.stars(),
                    title: R.string.localizable.settingsRateApp(),
                    rightType: .arrow
                )
            ),
        ], [
            SettingsModel(type: .button)
        ]]
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
        let model = dataSource[indexPath.section][indexPath.row]
        
        switch model.type {
        case let .cell(image, title, subtitle, rightType):
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.description(), for: indexPath) as! SettingsCell
            
            cell.iconImageView.image = image
            cell.titleLabel.text = title
            cell.rightView.set(type: rightType)
            
            if let subtitle = subtitle {
                cell.setSubtitle(subtitle)
            }
            
            return cell
            
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsDeleteCell.description(), for: indexPath) as! SettingsDeleteCell
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
