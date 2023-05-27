import UIKit

class WalletHeaderView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.walletTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .left
        
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.plus(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.scanBarcode(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    override func setup() {
        
        addSubview(titleLabel)
        addSubview(plusButton)
        addSubview(scanButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24.0)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(scanButton.snp.left).offset(-24.0)
            make.size.equalTo(24.0)
        }
        
        scanButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(24.0)
        }
    }
}
