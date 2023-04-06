import UIKit

class SettingsCell: UITableViewCell {

    let iconImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 16, weight: .medium)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(24.0)
            make.top.equalToSuperview().offset(20.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20.0)
            make.left.equalTo(iconImageView.snp.right).offset(16.0)
        }
    }

}
