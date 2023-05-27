import UIKit

class SendConfirmView: RootView {
    
    let commentView: ConfirmCommentView = ConfirmCommentView()
    let detailsView: ConfirmDetailsView = ConfirmDetailsView()
    
    let headerView: SendHeaderView = {
        let view = SendHeaderView()
        view.titleLabel.text = localizable.sendConfirmTitle()
        
        return view
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(localizable.sendConfirmButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .init(hex6: 0x0066FF)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(commentView)
        addSubview(detailsView)
        addSubview(confirmButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        commentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(21.0)
            make.left.right.equalToSuperview()
        }
        
        detailsView.snp.makeConstraints { make in
            make.top.equalTo(commentView.snp.bottom).offset(24.0)
            make.left.right.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-15.0)
            make.height.equalTo(60)
        }
        
    }

}
