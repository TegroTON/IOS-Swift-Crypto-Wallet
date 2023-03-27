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
        view.clipsToBounds = true
        
        return view
    }()
    
    let wavesImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.stackedWaves()
        view.contentMode = .scaleAspectFill
        view.alpha = 0.8
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
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
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "697 TON"
        label.font = .interFont(ofSize: 24, weight: .semiBold)
        label.textColor = .white
        
        return label
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
        
        return view
    }()
    
    init(type: CardType) {
        self.type = type
        super.init(frame: .zero)
        
        addSubview(shadowView)
        addSubview(containerView)
        
        containerView.addSubview(wavesImageView)
        containerView.addSubview(dimondImageView)
        containerView.addSubview(settingsButton)
        containerView.addSubview(nameLabel)
        containerView.addSubview(balanceLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(copyImage)
        containerView.addSubview(sendButton)
        containerView.addSubview(receiveButton)
        
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        settingsButton.isHidden = type == .settings
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20.0)
            make.height.equalTo(20)
        }
        
        dimondImageView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
        
        wavesImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(16.0 + 10.0 + 10.0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(16.0)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(nameLabel.snp.bottom).offset(12.0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(16.0)
            make.left.equalToSuperview().offset(16.0)
            make.right.equalTo(sendButton.snp.left)
        }
        
        copyImage.snp.makeConstraints { make in
            make.left.equalTo(addressLabel.snp.right).offset(11.0)
            make.size.equalTo(14.0)
            make.centerY.equalTo(addressLabel.snp.centerY)
        }
                
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8.0)
            make.width.equalToSuperview().multipliedBy(0.4385964912)
            make.height.equalTo(45.0)
            make.bottom.equalToSuperview().offset(-8.0)
        }
        
        receiveButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.height.equalTo(45.0)
            make.width.equalToSuperview().multipliedBy(0.4385964912)
        }
    }
}
