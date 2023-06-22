import UIKit

class SecurityView: ModalView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.securityTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let tableView: TableView = {
        let view = TableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.description())
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.0)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
