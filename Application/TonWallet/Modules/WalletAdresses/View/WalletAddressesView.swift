import UIKit

class WalletAddressesView: ModalView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.walletSettingsAddressesTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let tableView: TableView = {
        let view = TableView()
        view.backgroundColor = .clear
        view.register(WalletAddressCell.self, forCellReuseIdentifier: WalletAddressCell.description())
        view.separatorStyle = .none 
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
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
            make.right.left.bottom.equalToSuperview()
        }
    }
    
}
