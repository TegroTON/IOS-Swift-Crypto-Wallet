//
//  MainViewController.swift
//  TonWallet
//
//  Created by Max Xaker on 27.01.2023.
//

import UIKit

class MainViewController: UIViewController {

    var mainView: MainView {
        return view as! MainView
    }
    
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
