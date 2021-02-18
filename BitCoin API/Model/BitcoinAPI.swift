//
//  BitcoinAPI.swift
//  BitCoin API
//
//  Created by Mehrdad on 2020-11-17.
//  Copyright © 2020 Seneca College. All rights reserved.
//

import Foundation

class BitcoinAPI {
    
    // Shared Instance
    static let shared = BitcoinAPI()
    // API Key
    static let apiKey = "ENTER API KEY HERE"
    static let apiHeader = "x-ba-key"
    
    // Endpoints
    enum Endpoint {
        static let baseURL = "https://apiv2.bitcoinaverage.com"
        
        case getPriceData(String)
        case getCurrencyCodes
        
        var stringValue: String {
            switch self {
            case .getPriceData(let currency):
                return Endpoint.baseURL + "/indices/global/ticker/" + "BTC\(currency)"
            case.getCurrencyCodes:
                return Endpoint.baseURL + "/constants/exchangerates/global"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    
    
    func get(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue(BitcoinAPI.apiKey, forHTTPHeaderField: BitcoinAPI.apiHeader)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
//            print(String(data: data, encoding: .utf8)!)
            completion(data, nil)
        }
        task.resume()
    }
    
        
}
