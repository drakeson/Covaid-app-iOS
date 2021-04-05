//
//  AccountVM.swift
//  Covaid
//
//  Created by Dr.Drake on 5/17/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation
import Firebase

class AccountVM: NSObject {
    
    typealias authenticationLoginCallBack = (_ status:Bool, _ message:String) -> Void
    var loginCallback:authenticationLoginCallBack?
    
    //MARK:- Register Screen Check
    func userRegister(_ name:String, email:String, password:String){
        if email.count  != 0 {
            if password.count != 0 {
                self.registerUser(name, email: email, password: password)
            } else {
                ///password empty
                self.loginCallback?(false, Covaid.passwordError)
            }
        } else if name.count  != 3 {
            // Name empty
            self.loginCallback?(false, Covaid.nameError)
        } else {
            self.loginCallback?(false, Covaid.emailError)
        }
    }
    
    //Register User
    fileprivate func registerUser(_ name:String, email:String, password:String) {
        print("Email: \(email), Password: \(password)")
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                self.loginCallback?(false, Covaid.errorMsg)
            } else {
                let user = Auth.auth().currentUser
                if user != nil {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.photoURL = Covaid.photoURL
                    changeRequest?.commitChanges { (error) in
                      self.loginCallback?(true, Covaid.successMsg)
                    }
                }
            }
        }
    }
    //MARK:- Registration End
    
    //MARK:- Login Screen Check
    func userLogin(_ email:String, password:String) {
            if email.count  != 0 {
                if password.count != 0 {
                    self.loginUser(email, password: password)
                } else {
                    ///password empty
                    self.loginCallback?(false, Covaid.passwordError)
                }
            } else {
                // email empty
                self.loginCallback?(false, Covaid.emailError)
            }
    }
    //Login User
    fileprivate func loginUser(_ email:String, password:String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                self.loginCallback?(false, Covaid.errorMsg)
            } else {
                let user = Auth.auth().currentUser
                if user != nil {
                    self.loginCallback?(true, Covaid.successMsg)
                }
            }
        }
    }
    
    //MARK:- Login Send
    
    
    
    //MARK:- Reset Password
    func userReset(_ email:String) {
            if email.count  != 0 {
                resetPass(email)
            } else {
                // email empty
                self.loginCallback?(false, Covaid.emailError)
            }
    }
    fileprivate func resetPass(_ email:String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                print(error.debugDescription)
                self.loginCallback?(false, Covaid.errorMsg)
            } else {
                self.loginCallback?(true, "Check your Email")
            }
            
        }
    }
    
    //MARK:- Login & Sign Up CompletionHandler
    func loginCompletionHandler(callBack: @escaping authenticationLoginCallBack) {
        self.loginCallback = callBack
    }
}
