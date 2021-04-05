//
//  User.swift
//  Covaid
//
//  Created by Dr.Drake on 5/20/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let name: String
    let email: String
}

extension User: CustomDebugStringConvertible  {
    var debugDescription: String {
        return """
        ID: \(id)
        Name: \(name)
        Email: \(email)
        """
    }
}
