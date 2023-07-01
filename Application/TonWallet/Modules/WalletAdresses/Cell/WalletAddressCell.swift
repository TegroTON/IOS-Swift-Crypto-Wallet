import UIKit

class WalletAddressCell: UITableViewCell {

    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 16, weight: .medium)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    let checkMarkImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.checkMark()
        
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.borderColor()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(versionLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(checkMarkImageView)
        contentView.addSubview(separatorView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkMarkImageView.isHidden = true
        addressLabel.text = nil
        versionLabel.text = nil
    }
    
    private func setupConstraints() {
        versionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20.0)
            make.left.equalToSuperview().offset(24.0)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(80.0)
            make.centerY.equalTo(versionLabel.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.3076923077)
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(versionLabel.snp.centerY)
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(18.0)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }

}
