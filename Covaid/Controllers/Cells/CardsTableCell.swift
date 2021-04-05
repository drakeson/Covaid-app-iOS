//
//  CardsTableCell.swift
//  Covaid
//
//  Created by Dr.Drake on 6/28/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit

class CardsTableCell: UITableViewCell {

    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardBrand: UILabel!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var defaultImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
