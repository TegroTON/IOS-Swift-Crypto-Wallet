import UIKit

class WalletCardView: RootView {

    let dimondImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.cardDimond()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    let wavesImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.stackedWaves()
        view.contentMode = .scaleAspectFill
        view.alpha = 0.8
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .init(hex6: 0x0066FF)
        layer.cornerRadius = 12
        layer.shadowColor = R.color.walletCardShadow()!.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    
        
        addSubview(wavesImageView)
        addSubview(dimondImageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        dimondImageView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }
        
        wavesImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
