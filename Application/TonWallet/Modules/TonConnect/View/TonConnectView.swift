import UIKit

class TonConnectView: RootView {

    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .red
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        
        return label
    }()

    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
    }

}
