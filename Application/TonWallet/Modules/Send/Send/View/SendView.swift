import UIKit
import SnapKit

class SendView: RootView {

    let headerView: SendHeaderView = SendHeaderView()
    let formView: SendFormView = SendFormView()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.sendButton(), for: .normal)
        button.setTitleColor(R.color.textSecond(), for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = R.color.btnSecond()
        button.isEnabled = false
        
        return button
    }()
    
    var sendButtonBottomConstraint: Constraint!
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(formView)
        addSubview(sendButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.height.equalTo(60.0)
            sendButtonBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0).constraint
        }
    }

}
