//
//  History.swift
//  Covaid
//
//  Created by Dr.Drake on 5/24/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation

class History {
    
    let id: String?
    let title: String?
    let date: String?
    let amount: String?
    
    init(id: String?, title: String?, date: String?, amount: String?) {
        self.id = id
        self.title = title
        self.date = date
        self.amount = amount
    }
}

