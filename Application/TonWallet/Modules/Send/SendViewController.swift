import UIKit

class SendViewController: UIViewController {

    var mainView: SendView {
        return view as! SendView
    }
    
    override func loadView() {
        view = SendView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
