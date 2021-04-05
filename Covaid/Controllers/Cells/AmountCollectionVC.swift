//
//  AmountCollectionVC.swift
//  Covaid
//
//  Created by Dr.Drake on 7/10/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit

class AmountCollectionVC: UICollectionViewCell {
    
    @IBOutlet weak var amountLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
