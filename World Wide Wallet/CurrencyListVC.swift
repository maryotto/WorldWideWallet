//
//  CurrencyListVC.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/25/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import UIKit

class CurrencyListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencies = ["US dollar",
                      "Euro",
                      "Japanese yen",
                      "Bulgarian lev",
                      "Czech koruna",
                      "Danish krone",
                      "Pound sterling",
                      "Hungarian forint",
                      "Polish zloty",
                      "Romanian leu",
                      "Swedish krona",
                      "Swiss franc",
                      "Icelandic krona",
                      "Norwegian krone",
                      "Croatian kuna",
                      "Russian rouble",
                      "Turkish lira",
                      "Australian dollar",
                      "Brazilian real",
                      "Canadian dollar",
                      "Chinese yuan renminbi",
                      "Hong Kong dollar",
                      "Indonesian rupiah",
                      "Israeli shekel",
                      "Indian rupee",
                      "South Korean won",
                      "Mexican peso",
                      "Malaysian ringgit",
                      "New Zealand dollar",
                      "Philippine peso",
                      "Singapore dollar",
                      "Thai baht",
                      "South African rand"]
    var symbols = ["USD",
                   "EUR",
                   "JPY",
                   "BGN",
                   "CZK",
                   "DKK",
                   "GBP",
                   "HUF",
                   "PLN",
                   "RON",
                   "SEK",
                   "CHF",
                   "ISK",
                   "NOK",
                   "HRK",
                   "RUB",
                   "TRY",
                   "AUD",
                   "BRL",
                   "CAD",
                   "CNY",
                   "HKD",
                   "IDR",
                   "ILS",
                   "INR",
                   "KRW",
                   "MXN",
                   "MYR",
                   "NZD",
                   "PHP",
                   "SGD",
                   "THB",
                   "ZAR"]
    var selected: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        for _ in currencies {
            selected.append(false)
        }
        for _ in symbols {
            selected.append(false)
        }
        
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var selectedSymbol: [String] = []
        for index in 0..<symbols.count {
            if selected[index] {
                selectedSymbol.append(symbols[index])
            }
        }
        symbols = selectedSymbol
    }
}

extension CurrencyListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyListTableViewCell
        cell.convertToCurrencyLabel?.text = currencies[indexPath.row]
        cell.currencySymbolLabel?.text = symbols[indexPath.row]
        cell.checkMarkLabel.text = (selected[indexPath.row] ? "✔️": "")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected[indexPath.row] = !selected[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyListTableViewCell
        cell.checkMarkLabel.text = (selected[indexPath.row] ? "✔️": "")
        print("indexPath.row = \(indexPath.row) selected[indexPath.row] = \(selected[indexPath.row])")
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
