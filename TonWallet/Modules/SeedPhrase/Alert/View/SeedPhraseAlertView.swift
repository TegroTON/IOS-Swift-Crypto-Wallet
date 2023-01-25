import UIKit
import Atributika

class SeedPhraseAlertView: RootView {

    let containerView: UIView = UIView()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhraseAlert()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.seedPhraseAlertTitle()
        label.font = .montserratFont(ofSize: 18, weight: .medium)
        label.textColor = R.color.textColor()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.29
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.montserratFont(ofSize: 14, weight: .medium))
            .foregroundColor(R.color.subtitleColor()!)
        
        label.attributedText = R.string.localizable.seedPhraseAlertSubtitle().styleAll(style)
        
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.seedPhraseButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.cornerRadius = 6
        button.backgroundColor = .init(hex6: 0x4285F4)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.background()
        addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(nextButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(20.0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(64.0)
            make.height.equalTo(48.0)
            make.left.right.equalToSuperview().inset(78.0)
            make.bottom.equalToSuperview()
        }
    }

}
