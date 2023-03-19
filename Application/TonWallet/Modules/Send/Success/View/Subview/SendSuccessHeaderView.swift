import UIKit

class SendSuccessHeaderView: RootView {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.seedPhraseCreated()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendSuccessTitle("TON")
        label.font = .interFont(ofSize: 24, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        label.textAlignment = .center
        
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.sendSuccessSubtitle()
        label.font = .interFont(ofSize: 16, weight: .regular)
        label.textColor = R.color.textSecond()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(100.0)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(32.0)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.0)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
}
