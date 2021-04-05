//
//  SinglePickerDetaSource.swift
//  Covaid
//
//  Created by Dr.Drake on 6/23/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import PickerButton

class SinglePickerDetaSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerValues: [String] = ["Round-Up", "Monthly", "Weekly", "One Time"]
    var pickerSelected = "Round-Up"
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelected = pickerValues[row] as String
         print("\(pickerValues[row])")
    }

}
