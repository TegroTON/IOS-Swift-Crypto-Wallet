import UIKit

class ReceiveView: RootView {

    let headerView: ReceiveHeaderView = ReceiveHeaderView()
    let walletAddressView: ReceiveWalletView = ReceiveWalletView()
    let qrView: ReceiveQRView = ReceiveQRView()
    
    let shareButton: UIButton = {
        var attributedString = AttributedString(R.string.localizable.receiveShare())
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .init(hex6: 0x0066FF)
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        configuration.attributedTitle = attributedString
        configuration.image = R.image.share()
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        
        return UIButton(configuration: configuration)
    }()
    
    let copyButton: UIButton = {
        var attributedString = AttributedString(R.string.localizable.receiveCopy())
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = R.color.btnSecond()
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = R.color.textPrimary()
        configuration.attributedTitle = attributedString
        configuration.image = R.image.copy20()?.withTintColor(R.color.textPrimary()!, renderingMode: .alwaysTemplate)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        
        return UIButton(configuration: configuration)
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(qrView)
        addSubview(walletAddressView)
        addSubview(shareButton)
        addSubview(copyButton)
        
        setupConstraints()
    }
    
    func set(address: String) {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.3
        
        let atrString = NSMutableAttributedString(string: address, attributes: [
            .foregroundColor: R.color.textSecond()!,
            .font: UIFont.interFont(ofSize: 14, weight: .regular),
            .paragraphStyle: style
        ])
        
        walletAddressView.addressLabel.attributedText = atrString
    }
    
    func set(qr image: UIImage?) {
        qrView.qrImageView.image = image
    }
    
    func updateLayers() {
        qrView.qrContainer.layer.borderColor = R.color.borderColor()?.cgColor
        walletAddressView.addressContainer.layer.borderColor = R.color.borderColor()?.cgColor
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        qrView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(70.0)
            make.bottom.equalTo(walletAddressView.snp.top).offset(-16.0)
        }
        
        walletAddressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70.0)
        }
        
        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
            make.bottom.equalTo(copyButton.snp.top).offset(-15.0)
        }
        
        copyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
    }

}
