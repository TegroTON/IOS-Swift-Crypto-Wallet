import UIKit

class SendSuccessDetailsView: ConfirmDetailsView {
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.sendSuccessAddContact(), for: .normal)
        button.setTitleColor(R.color.textPrimary(), for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        
        return button
    }()
    
    let borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = R.color.testBorder()?.cgColor
        layer.lineWidth = 1
        layer.lineDashPattern = [8, 8] // alternate 4 points on and 4 points off
        layer.fillColor = nil
        
        return layer
    }()
    
    override func setup() {
        detailsContainer.addSubview(addButton)
        addButton.layer.addSublayer(borderLayer)
        
        /// тут добавляются все вьюшки из супер вью и вызывается setupConstraints()
        super.setup()
        
        titleLabel.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.frame = addButton.bounds
        borderLayer.path = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: 10).cgPath
    }
    
    override func setupConstraints() {
        recipientValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        recipientLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        commissionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        commissionValueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        detailsContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
            make.right.equalToSuperview().inset(16.0)
            make.left.equalTo(commissionLabel.snp.right).offset(12.0)
        }
        
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16.0)
            make.top.equalTo(commissionValueLabel.snp.bottom).offset(26.0)
            make.bottom.equalToSuperview().offset(-16.0)
            make.height.equalTo(50.0)
        }
    }

}
