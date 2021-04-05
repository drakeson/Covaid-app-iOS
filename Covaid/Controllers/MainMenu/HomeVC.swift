//
//  HomeVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/18/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import Stripe
import SVProgressHUD
import SwiftKeychainWrapper

class HomeVC: UIViewController {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var goalAmt: UILabel!
    @IBOutlet weak var donatedAmt: UILabel!
    @IBOutlet weak var progres: UISlider!
    @IBOutlet weak var weeklyAmt: UILabel!
    @IBOutlet weak var monthlyAmt: UILabel!
    var week = ""
    var month = ""
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var dBtn: UIButton!
    let numberFormatter = NumberFormatter()
    var profileVM = ProfileInfo()
    var projectInfo = ProjectInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Covaid.background)!)
        // Do any additional setup after loading the view.
        intiViews()
        
        profileVM.profileInfoHandler { [weak self] (name, email, pic) in
            guard self != nil else {return}
            
            let data = try? Data(contentsOf: URL(string: pic)!)
            if let imageData = data {
                self!.profileImg.image = UIImage(data: imageData)
            }
        }
        self.profileVM.getProfile()
        
        getProjectDetails()
    }
    
    func getProjectDetails() {
        projectInfo.homeCompletionHandler { [weak self] (status, name, imageUrl, goal, collected, weekly, monthly, raised) in
            guard self != nil else {return}
            if status {
                let newGoal = Int(goal.replacingOccurrences(of: " USD", with: ""))
                let newCollected = Int(collected.replacingOccurrences(of: " USD", with: ""))
                
                //Convert String to Cureency Like Formart 7,000,000
                self!.numberFormatter.numberStyle = .decimal
                let fGoal = self!.numberFormatter.string(from: NSNumber(value:newGoal!))
                let fCol = self!.numberFormatter.string(from: NSNumber(value:newCollected!))
                
                self!.progres.maximumValue = Float(newGoal!)
                self!.progres.minimumValue = 0.0
                let valueF = Float(newCollected!)
                self!.progres.setValue(valueF, animated: true)
                
                self!.goalAmt.text = "$ \(fGoal!)"
                self!.donatedAmt.text = "$ \(fCol!)"
                self!.weeklyAmt.text = raised
                 //"$ \(monthly)"
                self!.month = monthly
                self!.week = weekly
                
                // Replace this String with image
                let data = try? Data(contentsOf: URL(string: imageUrl)!)
                if let imageData = data { self!.coverImg.image = UIImage(data: imageData) }
                
                let retrievedString: String? = KeychainWrapper.standard.string(forKey: "periodSaved")
                if retrievedString != nil {
                    self!.monthlyAmt.text = retrievedString?.uppercased()
                } else {
                    self!.monthlyAmt.text = "No Subscription"
                }
                
                //SVProgressHUD.showSuccess(withStatus: message)
            } else {
                SVProgressHUD.showError(withStatus: name)
            }
        }
        self.projectInfo.getProjectDetails("Home")
    }
    
    
    @IBAction func donatebtn(_ sender: Any) {        
        let payment = SelectVC()
        payment.modalPresentationStyle = .fullScreen
        self.present(payment, animated: true, completion: nil)
    }
    
    @IBAction func readMore(_ sender: Any) {
        let detailVC = ProjectVC()
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
    
    
    func intiViews() {
        dBtn.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        dBtn.layer.cornerRadius = dBtn.frame.height/3
        dBtn.layer.masksToBounds = true
        
        profileImg.layer.borderWidth = 3
        profileImg.layer.masksToBounds = false
        profileImg.layer.borderColor = UIColor(hex: Covaid.color3).cgColor
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
    }

}
