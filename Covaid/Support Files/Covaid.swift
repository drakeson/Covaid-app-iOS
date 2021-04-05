//
//  Covaid.swift
//  Covaid
//
//  Created by Dr.Drake on 5/17/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation

struct Covaid {
    
    //MARK:- GET URLS
    static let projectId = "123456"
    static let getProjectDetails = "https://app.covaidapp19.com/api/get_project/" + projectId
    static let deleteCard = "https://app.covaidapp19.com/api/delete_card/"
    static let unSubscribe = "https://app.covaidapp19.com/api/cancel_all_subscriptions/"
    static let savedCardDetails = "https://app.covaidapp19.com/api/get_saved_card/"
    
    //MARK:- POST URLS
    static let onePay = "https://app.covaidapp19.com/api/pay_once"
    static let saveCard = "https://app.covaidapp19.com/api/save_card"
    static let subscribeCard = "https://app.covaidapp19.com/api/project_subscribe"
    
    
    //MARK:- API KEYS
    static let stripe = "pk_test_682mLHXqyDjGRdVzw4an9d0700WDNjTOKg"
    static let googleClientID: String = "170665834985-g1tupdb9t60oon3r8dmt19sf8n76hi26.apps.googleusercontent.com"
    static let twitterKey = "R7FUNs5Xht749L03tgACuD43H"
    static let twitterSecret = "egWSgdBwfQr5n2duekArPcKyDsZmaxuLDOGaj0xDgpI6RcOkfQ"
    static let photoURL = URL(string: "http://via.placeholder.com/400x400")
    static let history  = "https://app.covaidapp19.com/api/get_user_history/"
    
    
    //MARK:- Table View Cells
    static let historyCell = "histCell"
    static let cellNib = "HistTableViewCell"
    
    static let cardCell = "cardCell"
    static let cardNib = "CardsTableCell"
    
    static let profileCell = "amountCell"
    static let profileNib = "AmountCollectionVC"
    
    //MARK:- Error Messages
    static let emailError = "Email should not be empty"
    static let passwordError = "Password should not be empty"
    static let nameError = "Name should not be empty"
    static let errorMsg = "Wrong Email or Password format!"
    static let successMsg = "Successful"
    
    //MARK:- Colors
    static let background = "background.png"
    static let color1 = "3F51B5"
    static let color2 = "673AB7"
    static let color3 = "9C27B0"
    static let color4 = "6200EE"
    
    //MARK:- Payments Types
    static let weekly = "weekly"
    static let monthly = "monthly"
    static let round = "roundoff"
    static let one = "onece"
}
