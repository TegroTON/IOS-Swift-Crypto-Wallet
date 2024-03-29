import UIKit

class SettingsButtonCell: UITableViewCell {

    let logoutButton: UIButton = {
        var attributedString = AttributedString(localizable.settingsLogoutButton())
        var container = AttributeContainer()
        container[AttributeScopes.UIKitAttributes.FontAttribute.self] = UIFont.interFont(ofSize: 16, weight: .medium)
        attributedString.mergeAttributes(container, mergePolicy: .keepNew)
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = R.image.logout20()?.withTintColor(R.color.textPrimary()!)
        configuration.imagePadding = 10
        configuration.attributedTitle = attributedString
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = R.color.btnSecond()
        configuration.baseForegroundColor = R.color.textPrimary()
        configuration.background.cornerRadius = 10
        configuration.cornerStyle = .fixed
        
        return UIButton(configuration: configuration)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        contentView.addSubview(logoutButton)
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40.0)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
        }
    }
}
