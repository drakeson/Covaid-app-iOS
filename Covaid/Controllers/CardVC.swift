//
//  CardVC.swift
//  Covaid
//
//  Created by Dr.Drake on 7/16/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import Alamofire
import CreditCardViewSwift
import DTGradientButton
import Firebase
import Stripe
import SVProgressHUD

class CardVC: UIViewController, CreditCardViewSwiftDelegate {

    var selectedAmount = ""
    var selectedType = ""
    var cardF = ""
    var exF = ""
    var cvcF = ""
    var payVM = PaymentVM()
    @IBOutlet weak var creditCardView: CreditCardViewSwift!
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payButton.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
               payButton.layer.cornerRadius = payButton.frame.height/3
               payButton.layer.masksToBounds = true
        
        creditCardView.delegate = self
    }

    
    
    //MARK:- Donation Button
    @IBAction func payBtn(_ sender: Any) {
        if self.selectedType == "One Time" { self.getToken(type: "once") }
        else if self.selectedType == "Weekly" { self.getToken(type: Covaid.weekly) }
        else if self.selectedType == "Monthly" { self.getToken(type: Covaid.monthly) }
        else { self.getToken(type: Covaid.round) }
    }
    
    //MARK:- Get Stripe Token
    func getToken(type:String){
        if cardF.count < 12 {
            print("Card Number: \(cardF)")
            SVProgressHUD.showError(withStatus: "Enter Correct Card Number")
        } else if exF.count != 5 && !exF.contains("/") {
            SVProgressHUD.showError(withStatus: "Enter correct expiry Date")
        } else if cvcF.count < 3 {
            SVProgressHUD.showError(withStatus: "Enter Correct CVC")
        } else {
            SVProgressHUD.show(withStatus: "Donating....")
            // Initiate the card
            
            let stripCard = STPCardParams()
            
            // Split the expiration date to extract Month & Year
            if self.exF.isEmpty == false {
                let myString: String = exF
                let myStringArr = myString.components(separatedBy: "/")
                let expMonth = UInt(myStringArr[0])
                let expYear = UInt(myStringArr[1])
                
                // Send the card info to Strip to get the token
                stripCard.number = self.cardF
                stripCard.cvc = self.cvcF
                stripCard.expMonth = expMonth!
                stripCard.expYear = expYear!
                stripCard.currency = "usd"
            }
            STPAPIClient.shared().createToken(withCard: stripCard) { (token, error) in
                if error != nil { print(error! as NSError)
                    return
                }
                else { self.payStripe(token: "\(token!)", amount: self.selectedAmount, type: type) }
            }
        }
    }
    
    
    func payStripe(token:String, amount: String, type:String){
        payVM.payCompletionHandler { [weak self] (status, message) in
            guard self != nil else {return}
            if status {
                //SVProgressHUD.showSuccess(withStatus: message)
                let mainVC = MainTabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                //self.present(payment, animated: true, completion: nil)
            } else { SVProgressHUD.showError(withStatus: message) }
        }
        self.payVM.payDonation(token, amount: amount, type: type)
    }
    
    
    //MARK:- Card Data Validation
    func cardDataValidated(name: String, cardNumber: String, cardExpiry: String, cvvNumber: String) {
        print("XXXX: " + cardNumber)
        self.cardF = cardNumber
        self.cvcF = cvvNumber
        self.exF = cardExpiry
    }
    
    @IBAction func backBtn(_ sender: Any) { self.dismiss(animated: true, completion: nil) }
    
}
