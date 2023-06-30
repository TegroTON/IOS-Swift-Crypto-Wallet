import UIKit

class WalletSettingsView: RootView {
    
    let headerView: WalletSettingsHeaderView = .init()
    let walletCardView: WalletCardView = .init(type: .settings)
    let walletNameView: WalletSettingsName = .init()
    
    let warningView: WarningView = {
        let view = WarningView()
        view.setWarningText(localizable.walletSettingsBackUp())
        
        return view
    }()
    
    let tableView: TableView = {
        let view = TableView()
        view.backgroundColor = .clear
        view.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.description())
        view.separatorStyle = .none
        view.estimatedRowHeight = UITableView.automaticDimension
        view.rowHeight = UITableView.automaticDimension
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(walletCardView)
        addSubview(warningView)
        addSubview(walletNameView)
        addSubview(tableView)
        
        setupConstraints()
    }
    
    func setupWalletInfo(with wallet: Wallet) {
        walletCardView.nameLabel.text = wallet.name
        walletCardView.balanceLabel.text = String(format: "%.1g", wallet.balance ?? 0.0) + " TON"
        walletCardView.addressLabel.text = (try? wallet.activeContract?.contract.address().toString()) ?? ""
        
        walletNameView.textField.text = wallet.name
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        walletCardView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        warningView.snp.makeConstraints { make in
            make.top.equalTo(walletCardView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview().inset(24.0)
        }

        walletNameView.snp.makeConstraints { make in
            make.top.equalTo(warningView.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview().inset(24.0)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(walletNameView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview()
        }
    }
    
}
