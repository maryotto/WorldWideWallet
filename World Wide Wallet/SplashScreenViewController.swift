//
//  SplashScreenViewController.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/27/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    @IBOutlet weak var walletImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yAtLoad = walletImageView.frame.origin.y
        walletImageView.frame.origin.y = view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {self.walletImageView.frame.origin.y = yAtLoad})

       
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ShowTableView", sender: nil)
        }
    
}
