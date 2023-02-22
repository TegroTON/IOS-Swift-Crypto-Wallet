import UIKit
import Atributika

class PasswordView: RootView {

    let indicatorsView: PassIndicatorsView = PassIndicatorsView()
    
    let textField: UITextField = {
        let view = UITextField()
        view.autocorrectionType = .no
        view.keyboardType = .numberPad
        view.autocapitalizationType = .none
        view.alpha = 0
        
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
//        view.image = R.image.password()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.passwordSetTitle()
        label.font = .montserratFont(ofSize: 18, weight: .medium)
//        label.textColor = R.color.textColor()
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
//            .foregroundColor(R.color.subtitleColor()!)
        
        label.attributedText = R.string.localizable.passwordSetTitle().styleAll(style)
        
        return label
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.passwordCreateButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.cornerRadius = 6
        button.backgroundColor = .init(hex6: 0x4285F4)
        
        return button
    }()
    
    override func setup() {
//        backgroundColor = R.color.background()
        
        addSubview(textField)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(indicatorsView)
        addSubview(nextButton)
        
        setupConstraints()
    }
    
    func setSubtitle(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.29
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.montserratFont(ofSize: 14, weight: .medium))
//            .foregroundColor(R.color.subtitleColor()!)
        
        subtitleLabel.attributedText = text.styleAll(style)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(35.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(80.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(40.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview().inset(30.0)
        }
        
        indicatorsView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48.0)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(48.0)
            make.bottom.equalToSuperview().offset(48.0)
        }
    }
}
