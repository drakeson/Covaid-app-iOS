//
//  ProfileVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/18/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SwiftKeychainWrapper

class ProfileVC: UIViewController {
    
    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var proName: UILabel!
    @IBOutlet weak var proEmail: UILabel!
    var profileVM = ProfileInfo()
    var payVm = PaymentVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Covaid.background)!)
        
        profileVM.profileInfoHandler { [weak self] (name, email, pic) in
            guard self != nil else {return}
            self!.proName.text = name
            self!.proEmail.text = email
            let data = try? Data(contentsOf: URL(string: pic)!)
            if let imageData = data {
                self!.proPic.image = UIImage(data: imageData)
            }
        }
        self.profileVM.getProfile()
        
        proPic.layer.borderWidth = 3
        proPic.layer.masksToBounds = false
        proPic.layer.borderColor = UIColor(hex: Covaid.color3).cgColor
        proPic.layer.cornerRadius = proPic.frame.height/2
        proPic.clipsToBounds = true
    }
    
    //MARK:- Campains
    @IBAction func campains(_ sender: Any) {
        let projectVC = ProjectVC()
        projectVC.modalPresentationStyle = .fullScreen
        self.present(projectVC, animated: true, completion: nil)
    }
    
    //MARK:- Payments
    @IBAction func payments(_ sender: Any) {
        let payment = PayVC()
        payment.selectedAmount = "5"
        payment.selectedType = "monthly"
        payment.modalPresentationStyle = .fullScreen
        self.present(payment, animated: true, completion: nil)
    }
    
    //MARK:- Subscriptions
    @IBAction func subscriptions(_ sender: Any) {
        let alertController = UIAlertController(title: "Cancel Subscription", message: "Confirm and end your Subcription now.", preferredStyle: .alert)
                
        let yes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.cancelSub()
        }
        
        let no = UIAlertAction(title: "No", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the destructive");
        }
        
        alertController.addAction(yes)
        alertController.addAction(no)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK:- ABOUT-US
    @IBAction func aboutUs(_ sender: Any) {
        let alert = UIAlertController(title: "Covaid", message: "It's recommended you bring your towel before continuing. It's recommended you bring your towel before continuing. It's recommended you bring your towel before continuing.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    


    func cancelSub(){
        SVProgressHUD.show(withStatus: "Cancelling..")
        payVm.payCompletionHandler {(status, message) in
            if status {
                SVProgressHUD.showSuccess(withStatus: message)
            } else{
                SVProgressHUD.showError(withStatus: message)
            }
        }
        self.payVm.cancelSub()
        
    }
    
    //MARK:- Log Out
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let _: Bool = KeychainWrapper.standard.removeObject(forKey: "periodSaved")
            let loginVc = LoginViewController()
            loginVc.modalPresentationStyle = .fullScreen
            self.present(loginVc, animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
}
