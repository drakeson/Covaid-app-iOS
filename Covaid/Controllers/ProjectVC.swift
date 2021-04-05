//
//  ProjectVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/25/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import DTGradientButton
import SVProgressHUD

class ProjectVC: UIViewController {

    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var tAmount: UILabel!
    @IBOutlet weak var rAmount: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pOrganisation: UILabel!
    @IBOutlet weak var pDesc: UILabel!
    @IBOutlet weak var donate: UIButton!
    @IBOutlet weak var dateBtn: UILabel!
    var projectInfo = ProjectInfo()
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Covaid.background)!)
        
        //MARK:-Donate Button
        donate.setGradientBackgroundColors([UIColor(hex: Covaid.color1), UIColor(hex: Covaid.color3)], direction: DTImageGradientDirection.toRight, for: UIControl.State.normal)
        donate.layer.cornerRadius = donate.frame.height/3
        donate.layer.masksToBounds = true
        
        getProjectDetails()
    }

    func getProjectDetails() {
        projectInfo.projectCompletionHandler { [weak self] (status, title, desc, postBy, deadLine, imageUrl, proGoal, raised, weekly, monthly) in
            guard self != nil else {return}
            if status {
                
                let newGoal = Int(proGoal.replacingOccurrences(of: " USD", with: ""))
                let newCollected = Int(raised.replacingOccurrences(of: " USD", with: ""))
                
                //MARK:- Convert String to Cureency Like Formart 7,000,000
                self!.numberFormatter.numberStyle = .decimal
                let fGoal = self!.numberFormatter.string(from: NSNumber(value:newGoal!))
                let fCol = self!.numberFormatter.string(from: NSNumber(value:newCollected!))
                
                self!.slider.maximumValue = Float(newGoal!)
                self!.slider.minimumValue = 0.0
                let valueF = Float(newCollected!)
                self!.slider.setValue(valueF, animated: true)
        
                self!.pTitle.text = title.uppercased()
                self!.pDesc.text = desc
                self!.pOrganisation.text = postBy
                self!.dateBtn.text = deadLine
                self!.tAmount.text = "$ \(fGoal!)"
                self!.rAmount.text = "$ \(fCol!)"
                
                
                let data = try? Data(contentsOf: URL(string: imageUrl)!)
                if let imageData = data {
                    self!.bannerImg.image = UIImage(data: imageData)
                }
                //SVProgressHUD.showSuccess(withStatus: message)
            } else {
                SVProgressHUD.showError(withStatus: title)
            }
        }
        self.projectInfo.getProjectDetails("")
    }
    

    @IBAction func donateBtn(_ sender: Any) {
        let payment = SelectVC()
        payment.modalPresentationStyle = .fullScreen
        self.present(payment, animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
