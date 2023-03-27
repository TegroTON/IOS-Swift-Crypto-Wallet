import UIKit

class SeedPhraseHeaderView: RootView {

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.back(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        label.text = R.string.localizable.seedPhraseReadTitle()
        
        return label
    }()
    
    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.copy24(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    override func setup() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(copyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16.0)
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(24.0)
        }
        
        copyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
