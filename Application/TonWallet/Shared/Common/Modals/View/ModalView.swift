import UIKit

class ModalView: RootView {
    
    var contentHeight: CGFloat = .zero
    var bottomViewHeight = UIScreen.main.bounds.height
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bgPrimary()
        
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.bgPrimary()
        
        return view
    }()
    
    private var frameObservation: NSKeyValueObservation?
    
    override func setup() {
        addSubview(contentView)
        addSubview(bottomView)
        
        frameObservation = contentView.observe(\.bounds, options: [.new]) { [weak self] _, change in
            guard let self = self else { return }
            
            if let newFrame = change.newValue {
                self.handleFrameChange(newFrame: newFrame)
            }
        }
        
        setupConstraints()
    }
    
    private func handleFrameChange(newFrame: CGRect) {
        contentHeight = newFrame.height
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.height.equalTo(bottomViewHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
