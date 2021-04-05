//
//  RegisterViewController.swift
//  Covaid
//
//  Created by Dr.Drake on 5/17/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import SVProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var nameF: UITextField!
    @IBOutlet weak var emailF: UITextField!
    @IBOutlet weak var passF: UITextField!
    var accountVM = AccountVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUp.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        signUp.layer.cornerRadius = signUp.frame.height/3
        signUp.layer.masksToBounds = true
    }

    @IBAction func signUpBtn(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Registering....")
        guard let name = self.nameF.text else {return}
        guard let email = self.emailF.text else {return}
        guard let password = self.passF.text else {return}
        
        accountVM.loginCompletionHandler { [weak self] (status, message) in
            guard self != nil else {return}
            if status {
                SVProgressHUD.showSuccess(withStatus: message)
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }
        accountVM.userRegister(name, email: email, password: password)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
