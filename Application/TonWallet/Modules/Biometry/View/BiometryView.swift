import UIKit
import Atributika

class BiometryView: ModalView {
    
    let titleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.16
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 24, weight: .semiBold))
            .foregroundColor(R.color.textPrimary()!)
    
        label.attributedText = "Quick sign-in\nwith Face ID".styleAll(style)
        
        return label
    }()
    
    let subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineHeightMultiple = 1.16
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
    
        label.attributedText = "Face ID allows uou to open your\nwallet faster without having\nto enter your password".styleAll(style)
        
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "faceid")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let enableButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .init(hex6: 0x0066FF)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Enable Face ID", for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(enableButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(124.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(18.0)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6.0)
            make.left.right.equalToSuperview()
        }
        
        enableButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48.0)
            make.height.equalTo(60.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalToSuperview().offset(-26.0)
        }
    }
}
