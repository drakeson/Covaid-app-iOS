//
//  ProfileInfo.swift
//  Covaid
//
//  Created by Dr.Drake on 5/24/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation
import Firebase

class ProfileInfo: NSObject {
    
    typealias profileCallBack = (_ status:Bool, _ message:String) -> Void
    var profileCB:profileCallBack?
    
    typealias profileInfo = (_ name:String, _ email:String, _ photo:String) -> Void
    var profileIn:profileInfo?
    
    func getProfile(){
        let user = Auth.auth().currentUser
        if let user = user {
            
            let name = user.displayName
            let email = user.email
            let photoURL = "\(user.photoURL!)"
            //MARK:- Delete This when u
            if email == nil {
                self.userProfile(name!, email: "Can't Get Email from Twitter", pic: photoURL)
            } else {
                self.userProfile(name!, email: email!, pic: photoURL)
            }
            
            
        }
    }
    
    fileprivate func userProfile(_ name:String, email:String, pic:String){
        self.profileIn?(name, email, pic)
    }
    
    //MARK:- Login & Sign Up CompletionHandler
    func profileCompletionHandler(callBack: @escaping profileCallBack) {
        self.profileCB = callBack
    }
    
    //MARK:- Profile Info CompletionHandler
    func profileInfoHandler(callBack: @escaping profileInfo) {
        self.profileIn = callBack
    }
}
