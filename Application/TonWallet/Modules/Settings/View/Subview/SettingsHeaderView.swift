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
    override func setup() {
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15.0)
            make.bottom.equalToSuperview().offset(-15.0)
        }
    }

}
