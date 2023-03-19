import UIKit

class SendSuccessView: RootView {
    
    let headerView: SendSuccessHeaderView = SendSuccessHeaderView()
    let detailsView: SendSuccessDetailsView = SendSuccessDetailsView()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(R.string.localizable.sendSuccessButton(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .interFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.backgroundColor = .init(hex6: 0x0066FF)
        
        return button
    }()
    
    override func setup() {
        backgroundColor = R.color.bgPrimary()
        
        addSubview(headerView)
        addSubview(detailsView)
        addSubview(doneButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(69.0)
            make.left.right.equalToSuperview().inset(24.0)
        }
        
        detailsView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(56.0)
            make.left.right.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24.0)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16.0)
            make.height.equalTo(60)
        }
    }
    
}
