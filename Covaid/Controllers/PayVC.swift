//
//  PayVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/28/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import Alamofire
import DTGradientButton
import Firebase
import Stripe
import SVProgressHUD

class PayVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedAmount = ""
    var selectedType = ""
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cardTable: UITableView!
    var paymentIntentClientSecret: String?
    var cards = [History]()
    var payVM = PaymentVM()
    let pickerDataSource = SinglePickerDetaSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
               payButton.layer.cornerRadius = payButton.frame.height/3
               payButton.layer.masksToBounds = true
        
        cardTable.dataSource = self
        cardTable.dataSource = self
        
        self.cardTable.register(UINib(nibName: Covaid.cardNib , bundle: nil), forCellReuseIdentifier: Covaid.cardCell)
        self.cardTable.allowsSelection = true
        self.cardTable.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCards()
    }
    
    
    //MARK:- Donation Button
    @IBAction func payBtn(_ sender: Any) {
        let payment = CardVC()
        payment.selectedAmount = selectedAmount
        payment.selectedType = selectedType
        payment.modalPresentationStyle = .fullScreen
        self.present(payment, animated: true, completion: nil)
    }
    
    //MARK:- Get Stripe Token Ends
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Load Cards
    func loadCards(){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        AF.request(Covaid.savedCardDetails + userID).responseJSON(completionHandler: { response in
            if let json = response.value {
                let status = response.response?.statusCode
                if status == 200 {
                    let histArray : NSArray  = json as! NSArray
                    for i in 0..<histArray.count{
                        //adding hero values to the hero list
                        self.cards.append(History(
                            id: (histArray[i] as AnyObject).value(forKey: "id") as? String,
                            title: (histArray[i] as AnyObject).value(forKey: "last_four") as? String,
                            date: (histArray[i] as AnyObject).value(forKey: "brand") as? String,
                            amount: (histArray[i] as AnyObject).value(forKey: "type") as? String
                        ))
                    }
                    SVProgressHUD.dismiss()
                    self.cardTable.reloadData()
                } else {
                    let payment = CardVC()
                    payment.selectedAmount = self.selectedAmount
                    payment.selectedType = self.selectedType
                    payment.modalPresentationStyle = .fullScreen
                    self.present(payment, animated: true, completion: nil)
                    SVProgressHUD.showInfo(withStatus: "No Saved Cards")
                }
            }
            
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = cards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Covaid.cardCell, for: indexPath) as! CardsTableCell
        
        cell.cardNumber.text = "Card Number : " + card.title!
        cell.cardBrand.text = "Brand: " + card.date!
        cell.cardType.text = "Type: " + card.amount!
        
        if card.date == "Visa" {
            cell.cardImg.image = UIImage(named: "visa")
        } else if card.date == "MasterCard" {
            cell.cardImg.image = UIImage(named: "mastercard")
        } else if card.date == "American Express"{
            cell.cardImg.image = UIImage(named: "american")
        } else if card.date == "Discover" {
            cell.cardImg.image = UIImage(named: "discover")
        } else if card.date == "Diners Club" {
            cell.cardImg.image = UIImage(named: "symbol")
        } else if card.date == "JCB" {
            cell.cardImg.image = UIImage(named: "jcb")
        } else if card.date == "UnionPay" {
            cell.cardImg.image = UIImage(named: "unionpay")
        } else {
            cell.cardImg.image = UIImage(named: "placeholder")
        }
        
        
        if indexPath.row != 0 { cell.defaultImg.isHidden = true }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardId = cards[(indexPath.row)].id!
        options(cardId: cardId)
    }
    
    //MARK:- Card Options
    func options(cardId: String) {
        
        
        let actionSheet = UIAlertController.init(title: "Select Card Option", message: nil, preferredStyle: .actionSheet)
        
        //MARK:- Donate RoundUp
        actionSheet.addAction(UIAlertAction.init(title: "Donate", style: UIAlertAction.Style.default, handler: { (action) in
            guard let userID = Auth.auth().currentUser?.uid else { return }
            self.payVM.payCompletionHandler { [weak self] (status, message) in
                guard self != nil else {return}
                if status {
                    SVProgressHUD.showSuccess(withStatus: message)
                    self!.dismiss(animated: true, completion: nil)
                } else {
                    SVProgressHUD.showError(withStatus: message)
                }
            }
            self.payVM.subscribe(userID, _type: self.selectedType)
        }))
        
        //MARK:- Delete Card
        actionSheet.addAction(UIAlertAction.init(title: "Delete Card", style: UIAlertAction.Style.default, handler: { (action) in
            SVProgressHUD.show(withStatus: "Deleting Card...")
            self.payVM.payCompletionHandler { [weak self] (status, message) in
                guard self != nil else {return}
                if status {
                    SVProgressHUD.showSuccess(withStatus: message)
                    self!.dismiss(animated: true, completion: nil)
                } else {
                    SVProgressHUD.showError(withStatus: message)
                }
            }
            self.payVM.deleteCard(cardId)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

