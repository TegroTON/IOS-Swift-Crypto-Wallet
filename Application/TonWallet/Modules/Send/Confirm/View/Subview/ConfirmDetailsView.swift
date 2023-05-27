import UIKit

class ConfirmDetailsView: RootView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.sendConfirmDetails()
        label.font = .interFont(ofSize: 16, weight: .semiBold)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let detailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bgThird()
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let recipientLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.sendConfirmRecipient()
        label.font = .interFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let sumLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.sendConfirmSum()
        label.font = .interFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let commissionLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.sendConfirmCommission()
        label.font = .interFont(ofSize: 14, weight: .regular)
        label.textColor = R.color.textPrimary()
        
        return label
    }()
    
    let recipientValueLabel: UILabel = {
        let label = UILabel()
        label.text = localizable.sendConfirmRecipient()
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingMiddle
        
        return label
    }()
    
    let sumValueLabel: UILabel = {
        let label = UILabel()
        label.text = "300 TON"
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.textAlignment = .right
        
        return label
    }()
    
    let commissionValueLabel: UILabel = {
        let label = UILabel()
        label.text = "~ 0,00551003 TON"
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.textAlignment = .right
        
        return label
    }()
    
    override func setup() {
        addSubview(titleLabel)
        addSubview(detailsContainer)
        
        detailsContainer.addSubview(recipientLabel)
        detailsContainer.addSubview(recipientValueLabel)
        detailsContainer.addSubview(sumLabel)
        detailsContainer.addSubview(sumValueLabel)
        detailsContainer.addSubview(commissionLabel)
        detailsContainer.addSubview(commissionValueLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        recipientValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        recipientLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24.0)
        }
        
        detailsContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalToSuperview()
        }
        
        recipientLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16.0)
        }
        
        recipientValueLabel.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16.0)
            make.left.equalTo(recipientLabel.snp.right).offset(120.0)
        }
        
        sumLabel.snp.makeConstraints { make in
            make.top.equalTo(recipientLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(16.0)
        }
        
        sumValueLabel.snp.makeConstraints { make in
            make.top.equalTo(recipientValueLabel.snp.bottom).offset(8.0)
            make.right.equalToSuperview().offset(-16.0)
            make.left.equalTo(sumLabel.snp.right).offset(12.0)
        }
        
        commissionLabel.snp.makeConstraints { make in
            make.top.equalTo(sumLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(16.0)
        }
        
        commissionValueLabel.snp.makeConstraints { make in
            make.top.equalTo(sumValueLabel.snp.bottom).offset(8.0)
            make.bottom.right.equalToSuperview().inset(16.0)
            make.left.equalTo(commissionLabel.snp.right).offset(12.0)
        }
    }
}
