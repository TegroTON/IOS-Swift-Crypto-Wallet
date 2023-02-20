import UIKit
import Atributika

class LoadSeedView: RootView {
    
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
        view.image = R.image.loadSeed()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.loadTitle()
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
        
        let style = Style()
            .paragraphStyle(paragraphStyle)
            .font(.interFont(ofSize: 16, weight: .regular))
            .foregroundColor(R.color.textSecond()!)
        
        label.attributedText = R.string.localizable.loadSubtitle().styleAll(style)
        
        return label
    }()
    
    let animateView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex6: 0x0066FF)
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(backButton)
        addSubview(titlesBgView)
        addSubview(animateView)
        
        titlesBgView.addSubview(titlesContainer)
        
        titlesContainer.addSubview(imageView)
        titlesContainer.addSubview(titleLabel)
        titlesContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(24.0)
        }
        
        titlesBgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(animateView.snp.top)
            make.left.right.equalToSuperview()
        }
        
        titlesContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.centerX.equalToSuperview()
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
        
        animateView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-38.0)
            make.centerX.equalToSuperview()
            make.width.equalTo(44.0)
            make.height.equalTo(16.0)
        }
    }
    
}
