//
//  DetailVC.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/23/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var withdrawTextField: UITextField!
    @IBOutlet weak var transactionTextField: UITextField!
    @IBOutlet weak var currencyAmountTextField: UITextField!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var saveTransactionButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var convertedValue: UILabel!    
    @IBOutlet weak var convertToCurrencyLabel: UILabel!
    
    var defaultsData = UserDefaults.standard
    var imageNumber = 0
    var numOfImages = 5
    var card: String!
    var transactions: [String] = []
    var balance: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        transactions = defaultsData.stringArray(forKey: "transactions") ?? [String]()
        if card == nil {
            card = ""
        }
        cardNameTextField.text = card
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        card = cardNameTextField.text
    }
    
    func saveDefaultsData() {
        defaultsData.set(transactions, forKey: "transactions").self
    }
    
    @IBAction func equalButtonPressed(_ sender: UIButton) {
        let conversions = Conversions()
        conversions.currencyToConvertTo = convertToCurrencyLabel.text!
        conversions.getConversions {
            let myNewConversionValue = conversions.currencyRate
            let currencyAmount = Double(self.currencyAmountTextField.text!)
            var convertedDollarValue = Double(self.convertedValue.text!)
            convertedDollarValue = 1 / myNewConversionValue * currencyAmount!
            let roundedValue = String(format: "%.2f", convertedDollarValue!)
            self.convertedValue.text = "\(roundedValue)"
            self.currencyAmountTextField.text = ""
        }
    }
    
    
    @IBAction func cardTapped(_ sender: UITapGestureRecognizer) {
        imageNumber = imageNumber + 1
        if imageNumber == numOfImages {
            imageNumber = 0
        }
        cardImage.image = UIImage(named: "cc\(imageNumber)")
    }
    
    @IBAction func depositButtonPressed(_ sender: UIButton) {
        let newIndexPath = IndexPath(row: transactions.count, section: 0)
        transactions.append("+ $\(depositTextField.text!)")
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        let balance = Double(balanceLabel.text!)
        let deposit = Double(depositTextField.text!)
        if balance != nil && deposit != nil {
            let newBalance = Double(balance! + deposit!)
            let roundedBalance = String(format: "%.2f", newBalance)
            balanceLabel.text = "\(roundedBalance)"
            depositTextField.text = ""
        } else {
            balanceLabel.text = "\(0)"
        }
        saveDefaultsData()
    }
    @IBAction func withdrawButtonPressed(_ sender: UIButton) {
        let newIndexPath = IndexPath(row: transactions.count, section: 0)
        transactions.append("- $\(withdrawTextField.text!)")
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        let balance = Double(balanceLabel.text!)
        let withdraw = Double(withdrawTextField.text!)
        if balance != nil && withdraw != nil {
            let newBalance = Double(balance! - withdraw!)
            let roundedBalance = String(format: "%.2f", newBalance)
            balanceLabel.text = "\(roundedBalance)"
            withdrawTextField.text = ""
        } else {
            balanceLabel.text = "\(0)"
        }
        saveDefaultsData()
    }
    
    @IBAction func saveTransactionButtonPressed(_ sender: UIButton) {
        let newIndexPath = IndexPath(row: transactions.count, section: 0)
        transactions.append("$\(convertedValue.text!)   \(transactionTextField.text!)")
        tableView.insertRows(at: [newIndexPath], with: .bottom)
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        let balance = Double(balanceLabel.text!)
        let transaction = Double(convertedValue.text!)
        if balance != nil && transaction != nil {
            let newBalance = Double(balance! - transaction!)
            let roundedBalance = String(format: "%.2f", newBalance)
            balanceLabel.text = "\(roundedBalance)"
            depositTextField.text = ""
        } else {
            balanceLabel.text = "\(0)"
        }
        convertedValue.text = ""
        transactionTextField.text = ""
        saveDefaultsData()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    @IBAction func unwindFromCurrencyListVC(segue: UIStoryboardSegue) {
        let source = segue.source as! CurrencyListVC
        let itemsArray = source.symbols
        convertToCurrencyLabel.text = "\(itemsArray[0])"
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(transactions[indexPath.row])"
        cell.textLabel?.font = UIFont(name:"Avenir Next Condensed", size:20)
        return cell
    }
    
    
}
