import UIKit

class SendView: RootView {

    let headerView: SendHeaderView = SendHeaderView()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
    }

}
