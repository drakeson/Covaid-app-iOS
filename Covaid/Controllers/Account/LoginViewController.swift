//
//  LoginViewController.swift
//  Covaid
//
//  Created by Dr.Drake on 5/17/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import FirebaseAuth
import TwitterKit
import FacebookLogin
import GoogleSignIn
import SVProgressHUD
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailF: UITextField!
    @IBOutlet weak var passwordF: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logTxt: UILabel!
    
    var accountVM = AccountVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Buttons Button
        SetLoginButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.goToMain()
    }
    
    //MARK:- Login Button Pressed
    @IBAction func loginBtn(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Logging In....")
        guard let email = self.emailF.text else {return}
        guard let password = self.passwordF.text else {return}
        DispatchQueue.main.async {
            self.accountVM.loginCompletionHandler { [weak self] (status, message) in
                guard self != nil else {return}
                if status {
                    self!.goToMain()
                } else {
                    SVProgressHUD.showError(withStatus: message)
                }
            }
            self.accountVM.userLogin(email, password: password)
        }
    }
    
    //MARK:- Forgot Button
    @IBAction func forgotP(_ sender: Any) {
        let resetVC = ForgotViewController()
        resetVC.modalPresentationStyle = .fullScreen
        self.present(resetVC, animated: true, completion: nil)
    }
    
    //MARK:- Register button
    @IBAction func signUp(_ sender: Any) {
        let regVC = RegisterViewController()
        regVC.modalPresentationStyle = .fullScreen
        self.present(regVC, animated: true, completion: nil)
    }
    
    //MARK:- Google Button
    @IBAction func gBtn(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Logging In....")
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //MARK:- Facebook Button
    @IBAction func fBtn(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Logging In....")
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions:[ .publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login process.")
            case .success(granted: _, declined: _, token: let token):

                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential) { (result,error) in
                    print("FB Worked")
                    self.goToMain()
                }
            }
        }
    }
    
    
    fileprivate func SetLoginButtons() {
        let underlineAttriString = NSAttributedString(string:"or Login with", attributes:
            [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

        logTxt.attributedText = underlineAttriString
        
        //MARK:- Email Login
        login.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        login.layer.cornerRadius = login.frame.height/3
        login.layer.masksToBounds = true
        
        //MARK:- Google SignIn Button
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        //MARK:- Set Apple Button
        let appleBtn = ASAuthorizationAppleIDButton()
        appleBtn.translatesAutoresizingMaskIntoConstraints = false
        appleBtn.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

        view.addSubview(appleBtn)
        appleBtn.frame = CGRect(x:20, y: 600, width: 300, height: 40)
        NSLayoutConstraint.activate([
            appleBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 170),
            appleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            appleBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            appleBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    @objc
    func didTapAppleButton(){
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    //MARK:- Twitter Login
    @IBAction func tLogin(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Logging In....")
        TWTRTwitter.sharedInstance().logIn{ (session, error) in
            if error != nil {
                print("Error with twitter:: \(error!)")
                return
            }

            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if error != nil {
                    print("Error Credentials with twitter:: \(error!)")
                    return
                } else {
                    self.goToMain()
                }
                

            })
        }
    }
    
    //MARK:- Go to Home Screen
    func goToMain(){
        if Auth.auth().currentUser != nil {
              let mainVC = MainTabBarController()
              mainVC.modalPresentationStyle = .fullScreen
              self.present(mainVC, animated: true, completion: nil)
        } else {
          // No user is signed in.
          print("nil")
        }
    }
    
}
