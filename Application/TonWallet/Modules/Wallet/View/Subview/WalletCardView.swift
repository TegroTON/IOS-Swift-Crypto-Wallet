import UIKit
import SwiftUI

class WalletCardView: UIView {
    
    enum CardType {
        case `default`
        case settings
    }
    
    let type: CardType
    
    let buttonConfiguration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .fixed
        configuration.baseBackgroundColor = .init(white: 1, alpha: 0.2)
        configuration.baseForegroundColor = .white
        configuration.image = R.image.cardSend()
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        
        return configuration
    }()
    
    let dimondImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.cardDimond()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let wavesImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.stackedWaves()
        view.contentMode = .scaleAspectFill
        view.alpha = 0.8
        
        return view
    }()
    
    let settingsButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = R.image.cardSettings()
        configuration.contentInsets = .init(EdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0))
        
        return UIButton(configuration: configuration)
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ton Wallet"
        label.font = .interFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    let balanceButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .white
        configuration.contentInsets = .zero
        
        return UIButton(configuration: configuration)
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "wallet address"
        label.font = .interFont(ofSize: 14, weight: .regular)
        label.textColor = .init(hex6: 0xE8EFFB)
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    let copyImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.copy24()
        view.tintColor = .white
        
        return view
    }()
        
    lazy var sendButton: UIButton = {
        var configuration = buttonConfiguration
        var attributedString = AttributedString("Send")
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 14, weight: .semiBold)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        configuration.attributedTitle = attributedString
        
        return UIButton(configuration: configuration)
    }()
    
    lazy var receiveButton: UIButton = {
        var configuration = buttonConfiguration
        var attributedString = AttributedString("Receive")
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 14, weight: .semiBold)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        configuration.attributedTitle = attributedString
        configuration.image = R.image.cardReceive()
        configuration.imagePlacement = .leading
        
        return UIButton(configuration: configuration)
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.shadowColor = R.color.walletCardShadow()!.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0x0066FF)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    init(type: CardType) {
        self.type = type
        super.init(frame: .zero)
        
        sendButton.isHidden = true
        
        addSubview(shadowView)
        addSubview(containerView)
        
        containerView.addTapGesture(target: self, action: #selector(viewTapped))
        
        containerView.addSubview(wavesImageView)
        containerView.addSubview(dimondImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(balanceButton)
        containerView.addSubview(addressLabel)
        containerView.addSubview(copyImage)
        
        if type == .default {
            containerView.addSubview(settingsButton)
            containerView.addSubview(sendButton)
            containerView.addSubview(receiveButton)
        }
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            shadowView.layer.shadowColor = R.color.walletCardShadow()!.cgColor
        }
    }
    
    func setBalance(_ balance: Double) {
        let fontKey = AttributeScopes.UIKitAttributes.FontAttribute.self
        var container = AttributeContainer()
        container[fontKey] = UIFont.interFont(ofSize: 24, weight: .semiBold)
        
        let balance = String(format: "%.1g", balance) + " TON"
        var attributedString = AttributedString(balance)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        balanceButton.configuration?.attributedTitle = attributedString
    }
    
    @objc private func viewTapped() {
        UIPasteboard.general.string = addressLabel.text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        ToastController.showNotification(title: localizable.toastAddress())
    }
    
    private func setupConstraints() {
        wavesImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        dimondImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20.0)
            make.height.equalTo(20)
        }
        
        wavesImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.0)
            make.left.equalToSuperview().offset(14.0)
        }
        
        balanceButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14.0)
            make.top.equalTo(nameLabel.snp.bottom).offset(12.0)
            make.height.equalTo(24.0)
        }

        copyImage.snp.makeConstraints { make in
            make.left.equalTo(addressLabel.snp.right).offset(11.0)
            make.size.equalTo(14.0)
            make.centerY.equalTo(addressLabel.snp.centerY)
        }
        
        switch type {
        case .default:
            dimondImageView.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            settingsButton.snp.makeConstraints { make in
                make.top.right.equalToSuperview()
                make.size.equalTo(16.0 + 10.0 + 10.0)
            }
            
            addressLabel.snp.makeConstraints { make in
                make.top.equalTo(balanceButton.snp.bottom).offset(20.0)
                make.left.equalToSuperview().offset(14.0)
                make.width.equalTo(168.0)
//                make.right.equalTo(sendButton.snp.left)
            }

//            sendButton.snp.makeConstraints { make in
//                make.right.equalToSuperview().offset(-8.0)
//                make.width.equalToSuperview().multipliedBy(0.4385964912)
//                make.height.equalTo(45.0)
//                make.bottom.equalToSuperview().offset(-8.0)
//            }

            receiveButton.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(8.0)
                make.bottom.equalToSuperview().offset(-8.0)
                make.height.equalTo(45.0)
//                make.width.equalToSuperview().multipliedBy(0.4385964912)
                make.right.equalToSuperview().offset(-8.0)
            }
            
        case .settings:
            addressLabel.snp.makeConstraints { make in
                make.top.equalTo(balanceButton.snp.bottom).offset(20.0)
                make.left.equalToSuperview().offset(14.0)
                make.width.equalTo(168.0)
                make.bottom.equalToSuperview().offset(-16.0)
            }
            
            dimondImageView.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(12.0)
            }
        }
    }
}
