import UIKit

class SendConfirmViewController: UIViewController {

    var mainView: SendConfirmView {
        return view as! SendConfirmView
    }
    
    override func loadView() {
        view = SendConfirmView()
    }
    
    init(model: ConfirmDetailsModel) {
        super.init(nibName: nil, bundle: nil)
        
        updateContent(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: - Private methods
    
    // TODO: коммиссия только в тонах или в чем?
    private func updateContent(with model: ConfirmDetailsModel) {
        mainView.detailsView.recipientValueLabel.text = model.address
        mainView.detailsView.sumValueLabel.text = "\(model.amount) \(model.token)"
        mainView.detailsView.commissionValueLabel.text = "~ \(model.commission) TON"
    }
}
