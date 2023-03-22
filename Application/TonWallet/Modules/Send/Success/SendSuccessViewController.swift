import UIKit

class SendSuccessViewController: UIViewController {

    var mainView: SendSuccessView {
        return view as! SendSuccessView
    }
    
    override func loadView() {
        view = SendSuccessView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

}
