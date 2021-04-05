//
//  PaymentVM.swift
//  Covaid
//
//  Created by Dr.Drake on 5/29/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import Stripe
import SwiftKeychainWrapper

class PaymentVM: NSObject {
    
    
    typealias authenticationPayCallBack = (_ status:Bool, _ message:String) -> Void
    var payCallback:authenticationPayCallBack?
    
    //MARK:- One Time Payment
    func payDonation(_ token:String, amount:String, type:String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        if type == "once"{
            let params = [ "project_id": Covaid.projectId, "user_id": userID,
            "amount": amount, "stripeToken": token, "stripeEmail": userEmail ] as [String : Any]
            AF.request(Covaid.onePay, method: .post, parameters: params).responseJSON{
            response in
                let status = response.response?.statusCode
                if status == 200 {
                    switch response.result {
                    case let .success(value):
                        let jsonData = value as! NSDictionary
                        let message = jsonData.value(forKey: "message") as! String
                        self.payCallback!(true, message)
                        break
                    case let .failure(error):
                        print(error)
                        //self.payCallback!(true, message)
                    }
                } else if status == 500 || status == 502 || status ==  503 || status ==  504{
                    self.payCallback!(false, "Server Error")
                } else if status == 402 {
                    self.payCallback!(false, "Request Failed Try Again")
                } else {
                    self.payCallback!(false, "Try Again Later")
                }
            }
        } else {
            saveCard(token, type: type, email: userEmail, userId: userID)
        }
    }
    
    //MARK:- Save Card
    fileprivate func saveCard(_ token:String, type:String, email: String, userId: String) {
        let params = ["user_id": userId, "stripeToken": token, "stripeEmail": email ] as [String : Any]
        AF.request(Covaid.saveCard, method: .post, parameters: params).responseJSON{
        response in
            let status = response.response?.statusCode
            if status == 200 {
                switch response.result {
                case .success(_):
                    //Subscribe to Project
                    self.subscribe(userId, _type: type)
                    break
                case let .failure(error):
                    print(error)
                }
            } else if status == 500 || status == 502 || status ==  503 || status ==  504{
                print(response.description)
                self.payCallback!(false, "Server Error")
            } else if status == 402 {
                print(response.description)
                self.payCallback!(false, "Request Failed Try Again")
            } else {
                print(response.description)
                self.payCallback!(false, "Try Again Later")
            }
        }
    }
    //MARK:- Subscribe To Project
    func subscribe(_ userId:String, _type:String){
        let params = ["user_id": userId, "period": _type, "project_id": Covaid.projectId ] as [String : Any]
        AF.request(Covaid.subscribeCard, method: .post, parameters: params).responseJSON{
        response in
            let status = response.response?.statusCode
            if status == 200 {
                let _: Bool = KeychainWrapper.standard.set(_type, forKey: "periodSaved")
                switch response.result {
                case let .success(value
                    ):
                    let jsonData = value as! NSDictionary
                    let message = jsonData.value(forKey: "message") as! String
                    self.payCallback!(true, message)
                    break
                case let .failure(error):
                    print(error)
                }
            } else if status == 500 || status == 502 || status ==  503 || status ==  504{
                print(response.description)
                self.payCallback!(false, "Server Error")
            } else if status == 402 {
                print(response.description)
                self.payCallback!(false, "Request Failed Try Again")
            } else {
                print(response.description)
                self.payCallback!(false, "Try Again Later")
            }
        }
    }
    
    
    //MARK:- Cancel Subscription
    func cancelSub() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        AF.request(Covaid.unSubscribe+userID, method: .get).responseJSON{
        response in
            let status = response.response?.statusCode
            if status == 200 {
                switch response.result {
                case let .success(value):
                    let jsonData = value as! NSDictionary
                    let message = jsonData.value(forKey: "message") as! String
                    self.payCallback!(true, message)
                    break
                case let .failure(error):
                    print(error)
                    //self.payCallback!(true, message)
                }
            } else if status == 500 || status == 502 || status ==  503 || status ==  504{
                self.payCallback!(false, "Server Error")
            } else if status == 402 {
                self.payCallback!(false, "Request Failed Try Again")
            } else {
                self.payCallback!(false, "Try Again Later")
            }
        }
    }
    
    //MARK:- Cancel Subscription
    func deleteCard(_ cardID:String){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let deleteCard = Covaid.deleteCard+userID + "/" + cardID
        print("Delete \(deleteCard)")
        AF.request(deleteCard, method: .get).responseJSON{
        response in
            let status = response.response?.statusCode
            if status == 200 {
                switch response.result {
                case let .success(value):
                    let jsonData = value as! NSDictionary
                    let message = jsonData.value(forKey: "message") as! String
                    self.payCallback!(true, message)
                    break
                case let .failure(error):
                    print(error)
                    //self.payCallback!(true, message)
                }
            } else if status == 500 || status == 502 || status ==  503 || status ==  504{
                self.payCallback!(false, "Server Error")
            } else if status == 402 {
                self.payCallback!(false, "Request Failed Try Again")
            } else {
                self.payCallback!(false, "Try Again Later")
            }
        }
    }
    
    
    //MARK:- Login & Sign Up CompletionHandler
    func payCompletionHandler(callBack: @escaping authenticationPayCallBack) {
        self.payCallback = callBack
    }
}
