import UIKit

class ScanView: RootView {
    
    var isCenterMasked = false
    
    var frameImageView: UIImageView = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.close(), for: .normal)
        button.tintColor = .init(white: 1, alpha: 0.5)
        button.contentEdgeInsets = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
        
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.scanTitle()
        label.font = .interFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    let boxView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let flashButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 56/2
        button.backgroundColor = .init(hex6: 0x202427)
        button.setImage(R.image.energy(), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view .backgroundColor = .init(white: 0, alpha: 0.8)
        
        return view
    }()
    
    let blindView: UIView = {
        let view = UIView()
        view .backgroundColor = .black
        
        return view
    }()
    
    override func setup() {
        backgroundColor = .black
        
        addSubview(frameImageView)
        addSubview(blindView)
        addSubview(shadowView)
        addSubview(boxView)
        addSubview(closeButton)
        addSubview(flashButton)
        addSubview(titleLabel)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard
            !isCenterMasked,
            shadowView.bounds != .zero,
            boxView.frame != .zero
        else { return }
        
        isCenterMasked = true
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: shadowView.bounds)
        let squarePath = UIBezierPath(roundedRect: boxView.frame, cornerRadius: 10)

        path.append(squarePath.reversing())
        maskLayer.path = path.cgPath
        shadowView.layer.mask = maskLayer

        // Создаем слой с бордером в углах
        let borderLayer = CAShapeLayer()
        let borderPath = UIBezierPath()
        let border: CGFloat = 28
        let cornerRadius: CGFloat = 10
        
        //top left border
        borderPath.move(to: CGPoint(x: 0, y: border))
        borderPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
        borderPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: 10.0, startAngle: .pi, endAngle: (3.0 * CGFloat.pi)/2, clockwise: true)
        borderPath.addLine(to: CGPoint(x: border, y: 0))
        
        //top right border
        borderPath.move(to: CGPoint(x: boxView.bounds.width - border, y: 0))
        borderPath.addLine(to: CGPoint(x: boxView.bounds.width - cornerRadius, y: 0))
        borderPath.addArc(withCenter: CGPoint(x: boxView.bounds.width - cornerRadius, y: cornerRadius), radius: 10.0, startAngle: (3.0 * CGFloat.pi)/2, endAngle: 0, clockwise: true)
        borderPath.addLine(to: CGPoint(x: boxView.bounds.width, y: border))
        
        //bottom right border
        borderPath.move(to: CGPoint(x: boxView.bounds.width, y: boxView.bounds.height - border))
        borderPath.addLine(to: CGPoint(x: boxView.bounds.width, y: boxView.bounds.height - cornerRadius))
        borderPath.addArc(withCenter: CGPoint(x: boxView.bounds.width - cornerRadius, y: boxView.bounds.height - cornerRadius), radius: 10.0, startAngle: 0, endAngle: .pi/2, clockwise: true)
        borderPath.addLine(to: CGPoint(x: boxView.bounds.width - border, y: boxView.bounds.height))
        
        //bottom left border
        borderPath.move(to: CGPoint(x: border, y: boxView.bounds.height))
        borderPath.addLine(to: CGPoint(x: border - cornerRadius, y: boxView.bounds.height))
        borderPath.addArc(withCenter: CGPoint(x: cornerRadius, y: boxView.bounds.height - cornerRadius), radius: 10.0, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        borderPath.addLine(to: CGPoint(x: 0, y: boxView.bounds.height - border))
        
        borderLayer.path = borderPath.cgPath
        borderLayer.lineWidth = 3
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        boxView.layer.addSublayer(borderLayer)
    }
    
    func toggleFlashButton(isOn: Bool) {
        flashButton.backgroundColor = isOn ? .white : .init(hex6: 0x202427)
        flashButton.tintColor = isOn ? .black : .white
    }
    
    private func setupConstraints() {
        frameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blindView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(72.0)
        }
        
        boxView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(45.0)
            make.height.equalTo(boxView.snp.width)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(boxView.snp.top).offset(-32.0)
            make.left.right.equalToSuperview()
        }
        
        flashButton.snp.makeConstraints { make in
            make.top.equalTo(boxView.snp.bottom).offset(56.0)
            make.size.equalTo(56.0)
            make.centerX.equalToSuperview()
        }
    }

}
