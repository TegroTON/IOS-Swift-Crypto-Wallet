import UIKit

class SuccessViewController: UIViewController {

    var mainView: SuccessView {
        return view as! SuccessView
    }
    
    override func loadView() {
        view = SuccessView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.didAppear()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mainView.willDisappear()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: false)
            }
        }
    }

}
