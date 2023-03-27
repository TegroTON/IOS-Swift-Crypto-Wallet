import UIKit

class ReceiveWalletView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.receiveWallet()
        label.font = .interFont(ofSize: 16, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let addressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bgInputs()
        view.layer.cornerRadius = 10
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.receiveWallet()
        label.font = .interFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.textSecond()
        label.numberOfLines = 0
        
        return label
    }()
    
    let copyImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.copy20()
        
        return view
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(addressContainer)
        
        addressContainer.addSubview(addressLabel)
        addressContainer.addSubview(copyImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        addressContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
        }
        
        copyImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(16.0)
            make.size.equalTo(20.0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.right.equalTo(copyImageView.snp.left).offset(-19.0)
            make.left.equalToSuperview().offset(16.0)
            make.top.bottom.equalToSuperview().inset(13.0)
        }
    }

}
