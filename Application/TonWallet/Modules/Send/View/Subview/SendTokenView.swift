import UIKit

class SendTokenView: RootView {
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.ton()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TON"
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let otherImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.otherToken()
        view.tintColor = R.color.textPrimary()
        
        return view 
    }()
    
    override func setup() {
        backgroundColor = R.color.btnSecond()
        layer.cornerRadius = 6
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(otherImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(9.0)
            make.left.equalToSuperview().offset(18.0)
            make.size.equalTo(24.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(16.0)
            make.right.equalTo(otherImageView.snp.left).offset(-16.0)
        }
        
        otherImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().offset(-18.0)
            make.width.equalTo(3.0)
            make.height.equalTo(13.0)
        }
    }
    
}
