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
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
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
        label.text = localizable.passwordTitle()
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
        
        label.attributedText = localizable.passwordLoginSubtitle().styleAll(style)
        
        return label
    }()
    
    let titlesStack: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.alignment = .center
        view.axis = .vertical
        
        return view
    }()
    
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(backButton)
        addSubview(closeButton)
        addSubview(textField)
        addSubview(imageView)
        addSubview(titlesStack)
        addSubview(indicatorsView)
        
        titlesStack.addArrangedSubview(titleLabel)
        titlesStack.addArrangedSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    func setupContent(with type: ViewType) {
        switch type {
        case .create:
            backButton.isHidden = false
            closeButton.isHidden = true
            titleLabel.text = localizable.passwordCreateTitle()
            setSubtitle(text: localizable.passwordCreateSubtitle())
            
        case .check:
            closeButton.setImage(R.image.close(), for: .normal)
            backButton.isHidden = true
            closeButton.isHidden = false
            titleLabel.text = localizable.passwordTitle()
            setSubtitle(text: localizable.passwordConfirmSubtitle())
            
        case .login:
            closeButton.setImage(R.image.logout(), for: .normal)
            backButton.isHidden = true
            closeButton.isHidden = false
            titleLabel.text = localizable.passwordTitle()
            setSubtitle(text: localizable.passwordLoginSubtitle())
            
        case .change:
            closeButton.setImage(R.image.close(), for: .normal)
            backButton.isHidden = true
            closeButton.isHidden = false
            titleLabel.text = localizable.passwordCurrentTitle()
            setSubtitle(text: localizable.passwordCurrentSubtitle())
        }
    }
    
    func setBlockContent(blockSeconds: String) {
        indicatorsView.setAllIndicators(to: .blocked)
        titleLabel.text = localizable.passwordBlockTitle()
        setSubtitle(text: localizable.passwordBlockSubtitle(blockSeconds))
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
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.size.equalTo(24.0)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(72.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(100.0)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32.0)
            make.left.right.equalToSuperview()
        }
        
        indicatorsView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(176.0)
            make.centerX.equalToSuperview()
        }
    }
}
