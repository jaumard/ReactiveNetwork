//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String

    init(id: Int, name: String, username: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
    }
}