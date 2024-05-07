//
//  CoinModel.swift
//  ByteCoin
//
//  Created by 이가을 on 5/7/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let currency: Double
    let selectedCurrency: String
    
    var currencyString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        let comma = numberFormatter.string(from: NSNumber(value: currency))!
        return comma
    }
}
