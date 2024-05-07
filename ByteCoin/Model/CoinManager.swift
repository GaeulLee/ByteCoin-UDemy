//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinModel(coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "FA3E0EEE-2396-4D69-94D2-8B1BBFD2A812"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","KRW"]
    
    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)\(currency)?ApiKey=\(apiKey)"
        print(url)
        performResquest(with: url)
    }
    
    func performResquest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //print(String(data: safeData, encoding: .utf8))
                    if let coin = parseJSON(data: safeData) {
                        self.delegate?.didUpdateCoinModel(coinManager: self, coinModel: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let currency = decodedData.rate
            let selectedCurrency = decodedData.asset_id_quote
            let coinModel = CoinModel(currency: currency, selectedCurrency: selectedCurrency)
            
            return coinModel
        } catch {
            return nil
        }
    }
    
}
