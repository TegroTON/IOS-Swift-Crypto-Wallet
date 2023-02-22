import UIKit
import Atributika

class LoadSeedView: RootView {
    
    let titlesBgView: UIView = UIView()
    let titlesContainer: UIView = UIView()
    let animateContainer: UIView = UIView()
    let animateView: LoadAnimateView = LoadAnimateView()
    
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
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(titlesBgView)
        addSubview(animateContainer)
        
        animateContainer.addSubview(animateView)
        titlesBgView.addSubview(titlesContainer)
        
        titlesContainer.addSubview(imageView)
        titlesContainer.addSubview(titleLabel)
        titlesContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {        
        titlesBgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(animateContainer.snp.top)
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
        
        animateContainer.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
        }
        
        animateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(16.0)
        }
    }
    
}
