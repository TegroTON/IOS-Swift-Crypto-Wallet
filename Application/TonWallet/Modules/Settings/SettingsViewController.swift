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
                    rightType: .label("Eng")
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
            
            return cell
            
        case .button:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsDeleteCell.description(), for: indexPath) as! SettingsDeleteCell
            
            return cell
        }
    }
}
