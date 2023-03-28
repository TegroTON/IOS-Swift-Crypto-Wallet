import UIKit
import Atributika

class PasswordView: RootView {

    typealias ViewType = PasswordViewController.ViewType
    
    let indicatorsView: PassIndicatorsView = PassIndicatorsView()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.back(), for: .normal)
        button.tintColor = R.color.textPrimary()
        
        return button
    }()
    
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
        view.image = R.image.password()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.passwordSetTitle()
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
        
        label.attributedText = R.string.localizable.passwordSubtitle().styleAll(style)
        
        return label
    }()
    
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(backButton)
        addSubview(textField)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(indicatorsView)
        
        setupConstraints()
    }
    
    func setupContent(with type: ViewType) {
        switch type {
        case .check:
            backButton.isHidden = true
            titleLabel.text = R.string.localizable.passwordEnterTitle()
            setSubtitle(text: R.string.localizable.passwordEnterSubtitle())
            
        case .set:
            backButton.isHidden = false
            titleLabel.text = R.string.localizable.passwordSetTitle()
            setSubtitle(text: R.string.localizable.passwordSubtitle())
        }
    }
    
    func setBlockContent(blockSeconds: String) {
        indicatorsView.setAllIndicators(to: .blocked)
        titleLabel.text = R.string.localizable.passwordBlockTitle()
        setSubtitle(text: R.string.localizable.passwordBlockSubtitle(blockSeconds))
        imageView.alpha = 0.5
    }
    
    func setSubtitle(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.24
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        subtitleLabel.attributedText = text.styleAll(style)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.size.equalTo(24.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(72.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(100.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(30.0)
        }
        
        indicatorsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(112.0)
            make.centerX.equalToSuperview()
        }
    }
}
