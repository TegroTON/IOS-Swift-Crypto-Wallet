import UIKit
import RswiftResources
import SnapKit
import Atributika

class CreateView: RootView {

    let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = R.image.createBackground()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(R.color.secondTextColor(), for: .normal)
        button.setTitle(R.string.localizable.createPrivacy(), for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .medium)
        
        return button
    }()
    
    let connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(R.color.textColor(), for: .normal)
        button.setTitle(R.string.localizable.createConnectWallet(), for: .normal)
        button.backgroundColor = R.color.createNewButtonBackground()
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.borderColor = R.color.createNewButtonBorder()?.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 6.0
        
        return button
    }()
    
    let createNewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(R.string.localizable.createNewWallet(), for: .normal)
        button.backgroundColor = .init(hex6: 0x4285F4)
        button.titleLabel?.font = .montserratFont(ofSize: 14, weight: .semiBold)
        button.layer.cornerRadius = 6.0
        
        return button
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.33
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.montserratFont(ofSize: 16, weight: .medium))
            .foregroundColor(R.color.subtitleColor()!)
        
        label.attributedText = R.string.localizable.createSubtitle().styleAll(style)
        
        return label
    }()
    
    let createdByLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.createBy()
        label.font = .rubicFont(ofSize: 14, weight: .bold)
        label.textColor = R.color.textColor()
        label.textAlignment = .right
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.createTitle()
        label.font = .rubicFont(ofSize: 40, weight: .extraBold)
        label.textColor = R.color.textColor()
        label.textAlignment = .right
        
        return label
    }()
    
    let dimondImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.createDimond()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override func setup() {
        addSubview(backgroundImage)
        addSubview(privacyButton)
        addSubview(createNewButton)
        addSubview(connectButton)
        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(createdByLabel)
        addSubview(dimondImageView)
        
        setupConstraints()
    }
    
    func updateColors() {
        createNewButton.layer.borderColor = R.color.createNewButtonBorder()?.cgColor
    }
    
    private func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        privacyButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-14.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(24.0)
        }
        
        connectButton.snp.makeConstraints { make in
            make.bottom.equalTo(privacyButton.snp.top).offset(-131.0)
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(51.0)
        }
        
        createNewButton.snp.makeConstraints { make in
            make.bottom.equalTo(connectButton.snp.top).offset(-16.0)
            make.left.right.equalToSuperview().inset(78.0)
            make.height.equalTo(51.0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(56.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-30.0)
            make.centerX.equalToSuperview()
        }
        
        createdByLabel.snp.makeConstraints { make in
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).offset(-5.0)
        }
        
        dimondImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-48.0)
            make.size.equalTo(80.0)
        }
    }
    
}
