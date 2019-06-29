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
    
    var transactions: [Transaction] = []
    var transacetionSubset: [Transaction] = []
    var cardType = ""
    var cardBalance = 0.0
    
    var card: Card!
    var transaction: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        cardType = card.name
        cardBalance = card.limit
        print("** YOU PASSED OVER CARD NAME \(cardType)")
        cardNameTextField.text = cardType
        balanceLabel.text = "\(cardBalance)"
        loadData()
    }
    
    func updateTransaction() {
        for transaction in transactions {
            if transaction.card == cardType && transaction.balance == cardBalance {
                transacetionSubset.append(transaction)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         transaction.card = cardNameTextField.text!
        card.name = cardNameTextField.text!
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: "\(cardType)-transactions")
            print("*** Hurray! saving transactions worked!")
        } else {
            print("ERROR: saving transactions did not work")
        }
    }
    
    func loadData() {
        guard let transactionsEncoded = UserDefaults.standard.value(forKey: "\(cardType)-transactions") as? Data else {
            print("Could not load transactions data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let transactions = try? decoder.decode(Array.self, from: transactionsEncoded) as [Transaction] {
            self.transactions = transactions
        } else {
            print("ERROR: coudl not JSONdecode transaction from UserDefaults")
        }
        tableView.reloadData()
        calculateBalance()
    }
    
    func calculateBalance() {
        var sum = 0.0
        for transaction in transactions {
            sum = sum + transaction.amount
        }
        balanceLabel.text = "\(Double(round(100*(cardBalance - sum))/100))"
//        balanceLabel.text = "\(cardBalance - sum)"
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
    
    @IBAction func saveTransactionButtonPressed(_ sender: UIButton) {
        transactions.append(Transaction(card: cardType, amount: Double(convertedValue.text!) ?? 0.0, balance: Double(balanceLabel.text!) ?? 0.0, description: transactionTextField.text!))
        let balance = Double(balanceLabel.text!)
        let transactionValue = Double(convertedValue.text!)
        if balance != nil && transactionValue != nil {
            let newBalance = Double(balance! - transactionValue!)
            let roundedBalance = String(format: "%.2f", newBalance)
            balanceLabel.text = "\(roundedBalance)"
        } else {
            balanceLabel.text = "\(0)"
        }
        tableView.reloadData()
        convertedValue.text = ""
        transactionTextField.text = ""
        saveData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        cell.amountLabel?.text = "$\(transactions[indexPath.row].amount)"
        cell.descriptionLabel?.text = "\(transactions[indexPath.row].description)"
//        cell.dateLabel?.text = "\(transactions[indexPath.row].date)"
        cell.textLabel?.font = UIFont(name:"Avenir Next Condensed", size:20)
        return cell
    }
}
