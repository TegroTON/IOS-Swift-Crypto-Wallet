import UIKit
import SwiftUI

class WalletSettingsHeaderView: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.settingsTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = R.image.close()?.withTintColor(R.color.textPrimary()!)
        configuration.contentInsets = .init(EdgeInsets(top: 15.0, leading: 24.0, bottom: 15.0, trailing: 24.0))
        
        return UIButton(configuration: configuration)
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(closeButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15.0)
            make.bottom.equalToSuperview().offset(-15.0)
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
        }
    }
    
}
