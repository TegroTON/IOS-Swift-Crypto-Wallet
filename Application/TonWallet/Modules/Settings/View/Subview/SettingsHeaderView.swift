import UIKit
import SwiftUI

class SettingsHeaderView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.settingsTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let logoutButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = R.image.logout()?.withTintColor(R.color.textPrimary()!)
        configuration.contentInsets = .init(EdgeInsets(top: 16.0, leading: 24.0, bottom: 16.0, trailing: 24.0))
        
        return UIButton(configuration: configuration)
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(logoutButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(24.0 + 24.0 + 24.0)
            make.height.equalTo(16.0 + 24.0 + 16.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
