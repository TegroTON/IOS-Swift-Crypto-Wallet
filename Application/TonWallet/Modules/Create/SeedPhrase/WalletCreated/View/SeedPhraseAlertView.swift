import UIKit
import Atributika

class WalletCreatedView: RootView {

    let titlesBgView: UIView = UIView()
    let titlesContainer: UIView = UIView()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.back(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhraseCreated()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.seedPhraseCreatedTitle()
        label.font = .interFont(ofSize: 24, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        label.attributedText = localizable.seedPhraseCreatedSubtitle().styleAll(style)
        
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizable.seedPhraseButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .init(hex6: 0x0066FF)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(titlesBgView)
        addSubview(nextButton)
        addSubview(backButton)
        
        titlesBgView.addSubview(titlesContainer)
        
        titlesContainer.addSubview(imageView)
        titlesContainer.addSubview(titleLabel)
        titlesContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.size.equalTo(24.0)
        }
        
        titlesBgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        titlesContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.top.equalToSuperview().offset(8.0)
            make.size.equalTo(100.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.height.equalTo(60.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
    }

}
