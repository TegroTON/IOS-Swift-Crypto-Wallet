import UIKit
import Atributika
import Kingfisher

class TonConnectView: ModalView {

    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .secondaryLabel
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = R.color.textPrimary()
        label.font = .interFont(ofSize: 20, weight: .semiBold)
        
        return label
    }()
    
    let accessLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    let attentionLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.alignment = .center
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 14, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        label.attributedText = localizable.tonConnectAttentionTitle().styleAll(style)
        
        return label
    }()
    
    let allowButton: UIButton = {
        var attributedString = AttributedString(localizable.tonConnectAllowButton())
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .init(hex6: 0x0066FF)
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        configuration.attributedTitle = attributedString
        
        return UIButton(configuration: configuration)
    }()
    
    let cancelButton: UIButton = {
        var attributedString = AttributedString(localizable.tonConnectCancelButton())
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = R.color.btnSecond()
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = R.color.textPrimary()
        configuration.attributedTitle = attributedString
        
        return UIButton(configuration: configuration)
    }()

    override func setup() {
        super.setup()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(accessLabel)
        contentView.addSubview(attentionLabel)
        contentView.addSubview(allowButton)
        contentView.addSubview(cancelButton)
        
        setupConstraints()
    }
    
    func set(name: String) {
        let text = localizable.tonConnectTitle(name)
        titleLabel.text = text
    }
    
    func set(icon url: String) {
        guard let url = URL(string: url) else { return }
        iconImageView.kf.setImage(with: url)
    }
    
    func set(accessTo domain: String, wallet: String, version: String) {
        let sideLength: Int = 4
        let shortWallet: String = wallet.prefix(sideLength) + "..." + wallet.suffix(sideLength)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.alignment = .center
        
        let style = Style("all")
            .foregroundColor(R.color.textPrimary()!)
            .font(.interFont(ofSize: 16, weight: .regular))
            .paragraphStyle(paragraphStyle)
        
        let secondaryStyle = Style("secondary")
            .foregroundColor(R.color.textSecond()!)
            .font(.interFont(ofSize: 16, weight: .regular))
        
        accessLabel.attributedText = localizable.tonConnectAccessTitle(domain, shortWallet, version).style(tags: [style, secondaryStyle])
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25.0)
            make.left.right.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(68.0)
        }
        
        accessLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview()
        }
        
        attentionLabel.snp.makeConstraints { make in
            make.top.equalTo(accessLabel.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview()
        }
        
        allowButton.snp.makeConstraints { make in
            make.top.equalTo(attentionLabel.snp.bottom).offset(32.0)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-24.0)
            make.width.equalToSuperview().multipliedBy(0.4153846154)
            make.height.equalTo(60.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24.0)
            make.width.equalToSuperview().multipliedBy(0.4153846154)
            make.height.equalTo(60.0)
            make.centerY.equalTo(allowButton.snp.centerY)
        }
    }

}
