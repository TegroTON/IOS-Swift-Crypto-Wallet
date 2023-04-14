import UIKit

class SendConfirmViewController: UIViewController {

    let model: ConfirmDetailsModel
    
    var mainView: SendConfirmView {
        return view as! SendConfirmView
    }
    
    override func loadView() {
        view = SendConfirmView()
    }
    
    init(model: ConfirmDetailsModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        updateContent(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        mainView.headerView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        
        mainView.addGestureRecognizer(viewGesture)
    }

    // MARK: - Private actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func viewTapped() {
        mainView.endEditing(true)
    }
    
    @objc private func confirmButtonTapped() {
        let vc = PasswordViewController(type: .check)
        vc.successHandler = { [weak self] _ in
            guard let self = self else { return }
            
            let successVC = SendSuccessViewController(model: self.model)
            vc.navigationController?.pushViewController(successVC, animated: true)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private methods
    
    // TODO: коммиссия только в тонах или в чем?
    private func updateContent(with model: ConfirmDetailsModel) {
        mainView.detailsView.recipientValueLabel.text = model.address
        mainView.detailsView.sumValueLabel.text = "\(model.amount) \(model.token)"
        mainView.detailsView.commissionValueLabel.text = "~ \(model.commission) TON"
    }
}
