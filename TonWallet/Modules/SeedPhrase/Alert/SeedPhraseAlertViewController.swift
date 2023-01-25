import UIKit

class SeedPhraseAlertViewController: UIViewController {

    var mainView: SeedPhraseAlertView {
        return view as! SeedPhraseAlertView
    }
    
    override func loadView() {
        view = SeedPhraseAlertView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
