//
//  ProfileTableVC.swift
//  Covaid
//
//  Created by Dr.Drake on 5/25/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit

class ProfileTableVC: UITableViewCell {

    var proMenu: ProfileMenu? {
        didSet {
            guard let proTilte = proMenu?.title else { return }
            guard let proDesc = proMenu?.desc else { return }
            payTitle.text = proTilte
            payDesc.text = proDesc
        }
    }
    
    
    
    @IBOutlet weak var payTitle: UILabel! = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    
    @IBOutlet weak var payDesc: UILabel! = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
