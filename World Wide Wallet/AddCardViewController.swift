//
//  AddCardViewController.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/26/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {

    @IBOutlet weak var cardNameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    
    @IBOutlet weak var bigCardImage: UIImageView!
    
    var card = Card()
    var imageNumber = 0
    var numOfImages = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        card.name = cardNameField.text!
        card.limit = Double(balanceField.text!) ?? 0.0
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
}
