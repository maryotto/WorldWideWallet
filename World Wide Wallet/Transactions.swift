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

struct Transaction: Codable {
    var card: String
    var amount: Double
    var balance: Double
    var description: String
//    var date: String
}

