//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class Post: Codable {
    let id: Int?
    let userId: Int
    let title: String
    let body: String

    init(id: Int?, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}