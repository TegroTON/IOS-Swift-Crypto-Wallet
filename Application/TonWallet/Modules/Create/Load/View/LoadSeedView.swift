import UIKit

class LoadSeedView: RootView {

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.back(), for: .normal)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
}
