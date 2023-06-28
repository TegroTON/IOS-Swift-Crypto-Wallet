import UIKit

class WalletSettingsName: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.walletSettingsWalletName()
        label.font = .interFont(ofSize: 16, weight: .medium)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let textField: TextField = {
        let field = TextField()
        field.contentInset = UIEdgeInsets(top: 13.0, left: 16.0, bottom: 13.0, right: 16.0)
        field.text = "TON Wallet"
        field.backgroundColor = R.color.bgInputs()
        field.layer.borderColor = R.color.borderColor()?.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 10
        field.font = .interFont(ofSize: 14, weight: .medium)
        field.textColor = R.color.textPrimary()
        
        return field
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(textField)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.height.equalTo(54.0)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
