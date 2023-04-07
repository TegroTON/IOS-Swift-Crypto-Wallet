import UIKit

class SettingsRightView: RootView {

    typealias ViewType = SettingsModel.RightViewType
    
    private var isGradientSetted: Bool = false
    private let badgeContainer: UIView = .init()
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = R.color.textPrimary()
        view.image = R.image.chevronLeft()
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 14, weight: .medium)
        label.textColor = R.color.textSecond()
        label.textAlignment = .right
        
        return label
    }()
    
    let badgeLabel: UILabel = {
        let label = UILabel()
        label.font = .interFont(ofSize: 14, weight: .semiBold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isGradientSetted && badgeContainer.bounds != .zero {
            isGradientSetted = true
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(hex6: 0x0066FF).cgColor, UIColor(hex6: 0x0B4BF0).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = badgeContainer.bounds
            gradientLayer.cornerRadius = 24/2
            
            badgeContainer.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func set(type: ViewType) {
        switch type {
        case .badge(let number):
            setup(badge: number)
            
        case .label(let text):
            setup(label: text)
            
        case .switch:
            setupSwitch()
            
        case .arrow:
            setupArrow()
        }
    }
    
    private func setup(badge number: Int) {
        badgeLabel.text = number.description
        
        removeSubviews()
        addSubview(badgeContainer)
        badgeContainer.addSubview(badgeLabel)
        
        badgeLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8.0)
            make.top.bottom.equalToSuperview().inset(4.0)
        }
        
        badgeContainer.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.right.equalToSuperview().offset(-24.0)
        }
    }
    
    private func setup(label text: String) {
        titleLabel.text = text
        
        removeSubviews()
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.right.equalToSuperview().offset(-24.0)
        }
    }
    
    private func setupArrow() {
        removeSubviews()
        addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.size.equalTo(18.0)
            make.centerY.left.equalToSuperview()
        }
    }
    
    private func setupSwitch() {}
    
    private func removeSubviews() {
        arrowImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        badgeContainer.removeFromSuperview()
    }
}
