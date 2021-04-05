//
//  HistTableViewCell.swift
//  Covaid
//
//  Created by Dr.Drake on 5/24/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit

class HistTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
