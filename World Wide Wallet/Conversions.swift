//
//  ConversionInfo.swift
//  World Wide Wallet
//
//  Created by Mary Otto on 6/25/19.
//  Copyright © 2019 Mary Otto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Conversions {
    
    
    var currencyToConvertTo = ""
    var date = ""
    var currencyRate = 0.0
    var apiURL = "https://api.exchangeratesapi.io/latest?base=USD"
    
    func getConversions (completed: @escaping () -> ()) {
        Alamofire.request(apiURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                self.currencyRate = json["rates"][self.currencyToConvertTo].doubleValue
                self.date = json["date"].stringValue
            case .failure(let error):
                print("ERROR: \(error.localizedDescription) failed to get data from url \(self.apiURL)")
            }
            completed()
        }
    }
}

