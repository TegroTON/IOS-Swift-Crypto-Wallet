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

}
