//
//  ProjectInfo.swift
//  Covaid
//
//  Created by Dr.Drake on 6/7/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation
import Alamofire

class ProjectInfo: NSObject {
    
    typealias homeCallBack = (_ status:Bool, _ name:String, _ image:String, _ goal:String, _ collected:String, _ weekly:String, _ monthly:String, _ rasied:String) -> Void
    var homeScreen:homeCallBack?
    
    typealias projectCallBack = (_ status:Bool, _ name:String, _ description:String, _ author:String, _ deadline:String, _ image:String, _ goal:String, _ collected:String, _ weekly:String, _ monthly:String) -> Void
    var projectD:projectCallBack?
    
    
    //MARK:- Project Details
    func getProjectDetails(_ screen:String) {
        AF.request(Covaid.getProjectDetails, method: .get).responseJSON{
        response in
            let status = response.response?.statusCode
            if status == 200 {
                
                switch response.result {
                case let .success(value):
                    //print(value)
                    let jsonData = value as! NSDictionary
                    let title = jsonData.value(forKey: "name") as! String
                    let desc = jsonData.value(forKey: "description") as! String
                    let postBy = jsonData.value(forKey: "posted_by") as! String
                    let deadLine = jsonData.value(forKey: "days_left") as! String
                    let imageUrl = jsonData.value(forKey: "image_url") as! String
                    let proGoal = jsonData.value(forKey: "amount") as! String
                    let raised = jsonData.value(forKey: "collection") as! String
                    let weekly = jsonData.value(forKey: "weekly_pay") as! String
                    let monthly = jsonData.value(forKey: "monthly_pay") as! String
                    let raisedMonth = jsonData.value(forKey: "monthly_collection") as! String
                    
                    //Home Screen Details
                    if screen == "Home" {
                        //Change "https://bit.ly/2UmoMxh" with imageUrl
                        self.homeScreen?(true, title, imageUrl , proGoal, raised, weekly, monthly, raisedMonth)
                    } else {
                        //Project Details
                        //Change "https://bit.ly/2UmoMxh" with imageUrl
                        self.projectD?(true, title, desc, postBy, deadLine, imageUrl, proGoal, raised, weekly, monthly)
                    }
                case let .failure(error):
                    self.projectD?(false, "\(error)", "", "", "", "", "", "", "", "")
                    print(error)
                }
            }
        }
    }
    
    
    fileprivate func makePayment(_ cardNum:String, cardCVC:String, cardXpire:String, amount:String) {
        
    }
    
    //MARK:- Home Screen Project Details
    func homeCompletionHandler(callBack: @escaping homeCallBack) {
        self.homeScreen = callBack
    }
    
    //MARK:- Full Project Details
    func projectCompletionHandler(callBack: @escaping projectCallBack) {
        self.projectD = callBack
    }
}
