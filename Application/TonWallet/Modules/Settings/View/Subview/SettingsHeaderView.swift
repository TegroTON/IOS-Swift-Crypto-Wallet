import UIKit

class SettingsHeaderView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.settingsTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let quitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.logout(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    override func setup() {
        backgroundColor = .gray
        
        addSubview(titleLabel)
        addSubview(quitButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        quitButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(24.0 + 24.0 + 24.0)
            make.height.equalTo(16.0 + 24.0 + 16.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
