//
//  Transactions.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/26/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import Foundation


// cards: [String] - each string is a unique credit card
// transactions: Card: String, Amount: Double, DepositOrWith

struct Transaction {
    var card: String
    var amount: Double
    var description: String
}

var transactions: [Transaction] = []


// then in your code someplace
var cardType = "Visa" // or however you determine which ones you want to look at

// RIGHT HERE IS WHERE YOU'LL LOAD IN FROM USDRDEFAULTS
var transacetionSubset: [Transaction] = []

for transaction in transactions {
    if transaction.card == cardType {
        transacetionSubset.append(transaction)
    }
    transactions = newTransactions
