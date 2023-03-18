import UIKit
import SwiftUI

class SendHeaderView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendTitle()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = R.image.close()?.withTintColor(R.color.textPrimary()!)
        configuration.contentInsets = .init(EdgeInsets(top: 16.0, leading: 24.0, bottom: 16.0, trailing: 24.0))
        
        return UIButton(configuration: configuration)
    }()
        
    override func setup() {
        addSubview(titleLabel)
        addSubview(closeButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.width.equalTo(24 + 24 + 24)
            make.height.equalTo(16 + 24 + 16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}
