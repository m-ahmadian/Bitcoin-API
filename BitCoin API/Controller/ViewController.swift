//
//  ViewController.swift
//  BitCoin API
//
//  Created by Mehrdad on 2020-11-17.
//  Copyright © 2020 Seneca College. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    var index = 0
    var currencyList: [String]? {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set picker view delegate and dataSource to self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        BitcoinAPI.shared.get(url: BitcoinAPI.Endpoint.getCurrencyCodes.url, completion: handleCurrencyCodeResponse(data:error:))
        
    }
    
    
    // MARK: Helper Methods
    
    func handleCurrencyPriceResponse(data: Data?, error: Error?) {
        guard let data = data else {
            print(error?.localizedDescription ?? "")
            return
        }
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(CurrencyResponse.self, from: data)
            DispatchQueue.main.async {
                self.priceLabel.text = "\(responseObject.ask) \(self.currencyList![self.index])"
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func handleCurrencyCodeResponse(data: Data?, error: Error?) {
        guard let data = data else {
            print(error?.localizedDescription ?? "")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let responseObject = try decoder.decode(CurrencyCodes.self, from: data)
            let currencies = responseObject.rates.keys.map {$0}
            DispatchQueue.main.async {
                self.currencyList = currencies.sorted {$0 < $1}
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}



// MARK: UIPickerView Delegate & DataSource Methods
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyList![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
        BitcoinAPI.shared.get(url: BitcoinAPI.Endpoint.getPriceData(currencyList![row]).url, completion: handleCurrencyPriceResponse(data:error:))
    }
    
    
}

