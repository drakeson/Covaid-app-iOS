//
//  SelectVC.swift
//  Covaid
//
//  Created by Dr.Drake on 7/9/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import SVProgressHUD

class SelectVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var cont: UILabel!
    @IBOutlet weak var theTextfield: UITextField!
    let thePicker = UIPickerView()
    @IBOutlet weak var viewMode: UIView!
    @IBOutlet weak var donateBtn: UIButton!
    @IBOutlet weak var amountView: UICollectionView!
    @IBOutlet weak var amountL: UITextField!
    var projectInfo = ProjectInfo()
    let numberFormatter = NumberFormatter()
    var monthlyAmt = ""
    var weeklyAmt = ""
    var amountsF = ["$5", "$10", "$20", "$50", "$100"]
    let pickerValues: [String] = ["Round-Up", "Monthly", "Weekly", "One Time"]
    var pickerSelected = "Round-Up"
    @IBOutlet weak var mmCard: UIButton!
    @IBOutlet weak var cardCard: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Covaid.background)!)
        //MARK:-Donate Button
        donateBtn.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        donateBtn.layer.cornerRadius = donateBtn.frame.height/3
        donateBtn.layer.masksToBounds = true
        
        amountView.delegate = self
        amountView.dataSource = self
        self.amountView.register(UINib(nibName: Covaid.profileNib , bundle: nil), forCellWithReuseIdentifier: Covaid.profileCell)
        getProjectDetails()
        self.viewMode.isHidden = true
        
        theTextfield.inputView = thePicker
        thePicker.delegate = self
        self.mmCard.isHidden = true
    }
    
    //MARK:- Get Project Details
    func getProjectDetails() {
        projectInfo.projectCompletionHandler { [weak self] (status, title, desc, postBy, deadLine, imageUrl, proGoal, raised, weekly, monthly) in
            guard self != nil else {return}
            if status {
                self!.monthlyAmt = monthly
                self!.weeklyAmt = weekly
            }
        }
        self.projectInfo.getProjectDetails("")
    }
    
    //MARK:- Donation Button
    @IBAction func donateBtn(_ sender: Any) {
        if self.theTextfield.text == "" {
            SVProgressHUD.showError(withStatus: "Enter Donation Type")
        } else {
            var amount = ""
            if (amountL.text!.contains("$")) { amount = amountL.text!.replacingOccurrences(of: "$", with: "") }
            else { amount = amountL.text! }
            
            if self.theTextfield.text! == "Round-Up" {
                self.goToPay(title: self.theTextfield.text!, message: "All your Weekly transcation for your default card will be rounded off and charge", amount: amount)
            } else if self.theTextfield.text! == "Monthly" {
                self.goToPay(title: self.theTextfield.text!, message: "You will be charged \(amount) per Month", amount: amount)
            } else if self.theTextfield.text! == "Weekly" {
                self.goToPay(title: self.theTextfield.text!, message: "You will be charged \(amount) per Week", amount: amount)
            } else {
                self.goToPay(title: self.theTextfield.text!, message: "You will be charged \(amount) Once", amount: amount)
            }
        }
    }
    
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return amountsF.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Covaid.profileCell, for: indexPath) as! AmountCollectionVC
        cell.layer.cornerRadius = 10
        cell.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.2784313725, blue: 0.6666666667, alpha: 1)
        cell.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.2784313725, blue: 0.6666666667, alpha: 1)
        cell.layer.borderWidth = 2.0
        cell.amountLabel.text = self.amountsF[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.amountL.text = amountsF[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) { cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) { cell.backgroundColor = #colorLiteral(red: 0.3843137255, green: 0.2784313725, blue: 0.6666666667, alpha: 1) }
    }
    
    
    //MARK:- Collection View End
    
    //MARK:- Back Buttton
    @IBAction func backBtn(_ sender: Any) { self.dismiss(animated: true, completion: nil) }
    
    //MARK:- Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerValues[row] }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerValues.count }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelected = pickerValues[row] as String
        self.theTextfield.text = pickerValues[row] as String
         print("\(pickerValues[row])")
        if self.pickerSelected == "Round-Up" {
            self.amountL.isEnabled = false
            self.viewMode.isHidden = true
        } else if self.pickerSelected == "Weekly" {
            self.amountL.text = "$\(self.weeklyAmt)"
            self.amountL.isEnabled = false
            self.viewMode.isHidden = false
        } else if self.pickerSelected == "Monthly" {
            self.amountL.text = "$\(self.monthlyAmt)"
            self.amountL.isEnabled = false
            self.viewMode.isHidden = false
        } else {
            self.cont.text = "Enter Custom Amount"
            self.amountL.isEnabled = true
            self.viewMode.isHidden = false
        }
    }
    //MARK:- Picker View End
    
    //MARK:- Picker View
    func goToPay(title:String, message:String, amount:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
        let yes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
           let payment = PayVC()
           payment.selectedAmount = amount
           payment.selectedType = title
           payment.modalPresentationStyle = .fullScreen
           self.present(payment, animated: true, completion: nil)
        }
        
        let no = UIAlertAction(title: "No", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the destructive");
        }
        
        alertController.addAction(yes)
        alertController.addAction(no)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}
