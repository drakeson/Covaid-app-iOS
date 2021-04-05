//
//  ForgotViewController.swift
//  Covaid
//
//  Created by Dr.Drake on 5/18/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import SVProgressHUD

class ForgotViewController: UIViewController {

    @IBOutlet weak var emailF: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    var accountVM = AccountVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetBtn.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        resetBtn.layer.cornerRadius = resetBtn.frame.height/3
        resetBtn.layer.masksToBounds = true
        
    }
    @IBAction func rBtn(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Resetting....")
        guard let email = self.emailF.text else {return}
        accountVM.loginCompletionHandler { [weak self] (status, message) in
            guard self != nil else {return}
            if status {
                SVProgressHUD.showSuccess(withStatus: message)
            } else {
                SVProgressHUD.showError(withStatus: message)
            }
        }
        accountVM.userReset(email)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
