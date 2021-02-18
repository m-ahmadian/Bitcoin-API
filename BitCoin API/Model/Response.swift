//
//  CurrencyResponse.swift
//  BitCoin API
//
//  Created by Mehrdad on 2020-11-17.
//  Copyright © 2020 Seneca College. All rights reserved.
//

import Foundation

struct CurrencyResponse: Codable {
    let ask: Double
}


struct CurrencyCodes: Codable {
    let rates: [String: [String: String]]
}
