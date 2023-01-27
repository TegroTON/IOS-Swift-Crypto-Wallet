import UIKit

class MainView: RootView {

    let headerContainerView: UIView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mainTitle()
        label.font = .montserratFont(ofSize: 20, weight: .semiBold)
        label.textColor = R.color.textColor()
        label.textAlignment = .center
        
        return label
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.mainUpdate(), for: .normal)
        
        return button
    }()
    
    let copyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.mainCopy(), for: .normal)
        
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    override func setup() {
        backgroundColor = R.color.background()
        
        addSubview(headerContainerView)
        addSubview(collectionView)
        
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(copyButton)
        headerContainerView.addSubview(updateButton)
        
        setupConstraints()
    }

    private func setupConstraints() {
        headerContainerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18.0)
            make.centerX.equalToSuperview()
        }
        
        copyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24.0)
            make.top.bottom.equalToSuperview().inset(20.0)
            make.size.equalTo(24.0)
        }
        
        updateButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24.0)
            make.centerY.equalToSuperview()
            make.size.equalTo(24.0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
