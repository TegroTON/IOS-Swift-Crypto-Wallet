import UIKit

class TonConnectView: RootView {

    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .red
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        
        return label
    }()
    
    let connectButton: UIButton = {
        var attributedString = AttributedString("Connect")
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .init(hex6: 0x0066FF)
        configuration.background.cornerRadius = 10
        configuration.baseForegroundColor = .white
        configuration.attributedTitle = attributedString
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 10
        
        return UIButton(configuration: configuration)
    }()

    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(connectButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        connectButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20.0)
            make.left.right.equalToSuperview().inset(20.0)
            make.height.equalTo(48.0)
        }
    }

}
