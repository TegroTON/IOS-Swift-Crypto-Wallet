import UIKit
import RswiftResources
import SnapKit
import Atributika

class CreateView: RootView {
    
    let titlesBgView: UIView = UIView()
    let titlesContainer: UIView = UIView()
    
    let helloLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.createHello()
        label.font = .interFont(ofSize: 18, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.createLogo()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.createTitle()
        label.font = .interFont(ofSize: 32, weight: .extraBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.45
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        label.attributedText = localizable.createSubtitle().styleAll(style)
        
        return label
    }()
    
    let connectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(localizable.createConnectWallet(), for: .normal)
        button.backgroundColor = .init(hex6: 0x0066FF)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(R.color.textPrimary(), for: .normal)
        button.setTitle(localizable.createNewWallet(), for: .normal)
        button.backgroundColor = R.color.btnSecond()
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(helloLabel)
        addSubview(titlesBgView)
        addSubview(connectButton)
        addSubview(createButton)
        
        titlesBgView.addSubview(titlesContainer)
        
        titlesContainer.addSubview(logoImageView)
        titlesContainer.addSubview(titleLabel)
        titlesContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        helloLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15.0)
            make.left.right.equalToSuperview()
        }
        
        titlesBgView.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(connectButton.snp.top)
        }
        
        titlesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(80.0)
            make.height.equalTo(86.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(56.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32.0)
        }
        
        connectButton.snp.makeConstraints { make in
            make.bottom.equalTo(createButton.snp.top).offset(-12.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(56.0)
        }
        
        createButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(56.0)
        }
    }
    
}
