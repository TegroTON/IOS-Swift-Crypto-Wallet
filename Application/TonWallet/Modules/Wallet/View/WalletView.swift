import UIKit

class WalletView: RootView {

    let headerView: WalletHeaderView = WalletHeaderView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(collectionView)
        
        setupConstraints()
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
                
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
