import UIKit

class ReceiveQRView: RootView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.receiveQr()
        label.font = .interFont(ofSize: 16, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let qrContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.borderColor()?.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let qrImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
                
        return view
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(qrContainer)
        
        qrContainer.addSubview(qrImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        qrContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.right.bottom.left.equalToSuperview()
            make.height.equalTo(qrContainer.snp.width)
        }
        
        qrImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12.0)
        }
    }

}
