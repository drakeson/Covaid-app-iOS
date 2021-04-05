//
//  LoginExtentions.swift
//  Covaid
//
//  Created by Dr.Drake on 5/20/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices


extension LoginViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil && user.authentication != nil{
            let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                  return
                }
                self.goToMain()
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", accessToken: idTokenString)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print(error!.localizedDescription)
              return
            }
            self.goToMain()
          }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Something Happned ", error)
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
     
        return view.window!
    }
}
