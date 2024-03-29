import UIKit

class SettingsCell: UITableViewCell {

    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = R.color.textPrimary()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 16, weight: .medium)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    lazy var titlesStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 4
        
        return view
    }()
    
    // TODO: - Implement attributed label
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 12, weight: .regular)
        label.textColor = R.color.textSecond()
        label.numberOfLines = 0
        
        return label
    }()
    
    let rightView: SettingsRightView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(iconImageView)
        addSubview(titlesStack)
        addSubview(rightView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        subtitleLabel.removeFromSuperview()
    }
    
    func setSubtitle(_ subtitle: String?) {
        guard let subtitle = subtitle else { return }
        
        titlesStack.addArrangedSubview(subtitleLabel)
        subtitleLabel.text = subtitle
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.size.equalTo(24.0)
            make.top.equalToSuperview().offset(20.0)
        }
        
        titlesStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20.0)
            make.left.equalTo(iconImageView.snp.right).offset(16.0)
            make.right.equalToSuperview().offset(-120)
        }
        
        rightView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

}
