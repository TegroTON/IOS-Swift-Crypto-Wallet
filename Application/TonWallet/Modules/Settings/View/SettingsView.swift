import UIKit

class SettingsView: RootView {
    
    let headerView: SettingsHeaderView = SettingsHeaderView()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.description())
        view.register(SettingsDeleteCell.self, forCellReuseIdentifier: SettingsDeleteCell.description())
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }

}
