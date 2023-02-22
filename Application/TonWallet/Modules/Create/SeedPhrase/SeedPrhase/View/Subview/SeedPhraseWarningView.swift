import UIKit
import Atributika

class SeedPhraseWarningView: RootView {

    let infoImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.info()
        view.tintColor = .init(hex6: 0xF4AD42)
        
        return view
    }()
    
    let warningLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineHeightMultiple = 1.27
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 15, weight: .regular))
            .foregroundColor(R.color.textPrimary()!)
        
        label.attributedText = R.string.localizable.seedPhraseReadWarning().styleAll(style)
        
        return label
    }()

    
    override func setup() {
        backgroundColor = .init(hex6: 0xF4AD42, alpha: 0.12)
        layer.cornerRadius = 10
        
        addSubview(infoImageView)
        addSubview(warningLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        infoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(16.0)
            make.size.equalTo(24.0)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.0)
            make.bottom.equalToSuperview().offset(-22)
            make.right.equalToSuperview().offset(-36.0)
            make.left.equalTo(infoImageView.snp.right).offset(16.0)
        }
    }
    
}
