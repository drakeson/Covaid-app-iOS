//
//  HistoryVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/18/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SVProgressHUD
import SwiftyJSON

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var histTable: UITableView!
    var history = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: Covaid.background)!)
        
        //self.histTable.register(HistTableViewCell, forCellReuseIdentifier: Covaid.historyCell)
        
        histTable.dataSource = self
        histTable.dataSource = self
        
        self.histTable.register(UINib(nibName: Covaid.cellNib , bundle: nil), forCellReuseIdentifier: Covaid.historyCell)
        loadHistory()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hist = history[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Covaid.historyCell, for: indexPath) as! HistTableViewCell

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let amountInt = Int(hist.amount!)
        let amountF = numberFormatter.string(from: NSNumber(value: amountInt!))
        
        cell.titleLabel.text = "Project Name: \(hist.title!)"
        cell.dateLabel.text = "Payment Date: \(hist.date!)"
        cell.amountlabel.text = "Amount Donated: $ \(amountF!)"
        cell.backgroundColor = UIColor.clear
        cell.isOpaque = false
        return cell
    }
    
    func loadHistory() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        SVProgressHUD.show(withStatus: "Loading")
        AF.request(Covaid.history + userID).responseJSON(completionHandler: { response in
            if let json = response.value {
                if "\(json)" == "(\n)"  {
                    SVProgressHUD.showProgress(0.5, status: "Np History")
                    //SVProgressHUD.showInfo(withStatus: "Np History")
                } else {
                    let histArray : NSArray  = json as! NSArray
                    for i in 0..<histArray.count{
                        //adding hero values to the hero list
                        self.history.append(History(
                            id: (histArray[i] as AnyObject).value(forKey: "id") as? String,
                            title: (histArray[i] as AnyObject).value(forKey: "project_name") as? String,
                            date: (histArray[i] as AnyObject).value(forKey: "paid_at") as? String,
                            amount: (histArray[i] as AnyObject).value(forKey: "amount") as? String
                        ))
                    }
                    SVProgressHUD.dismiss()
                    self.histTable.reloadData()
                }
            }
            
        })
    }
    
    @IBAction func donateBtn(_ sender: Any) {
        let payment = SelectVC()
        payment.modalPresentationStyle = .fullScreen
        self.present(payment, animated: true, completion: nil)
    }
    
    
}
