import UIKit

class SendSuccessViewController: UIViewController {

    var mainView: SendSuccessView {
        return view as! SendSuccessView
    }
    
    init(model: ConfirmDetailsModel) {
        super.init(nibName: nil, bundle: nil)
        
        updateContent(with: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SendSuccessView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ///без этого метод layoutSubviews() в detailsView вызывается только с нулевыми ректами
        mainView.detailsView.setNeedsLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            mainView.detailsView.borderLayer.strokeColor = R.color.testBorder()?.cgColor
        }
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }

    private func updateContent(with model: ConfirmDetailsModel) {
        mainView.detailsView.recipientValueLabel.text = model.address
        mainView.detailsView.sumValueLabel.text = "\(model.amount) \(model.token)"
        mainView.detailsView.commissionValueLabel.text = "~ \(model.commission) TON"
    }
}
