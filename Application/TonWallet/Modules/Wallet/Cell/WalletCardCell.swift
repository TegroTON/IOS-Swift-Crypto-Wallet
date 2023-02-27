import UIKit

class WalletCardCell: UICollectionViewCell {
    
    let cardView: WalletCardView = WalletCardView(type: .default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24.0)
        }
    }
    
}
