import UIKit

class SettingsView: RootView {
    
    let headerView: SettingsHeaderView = SettingsHeaderView()
    
    let tableView: UITableView = {
        
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
    }

}
