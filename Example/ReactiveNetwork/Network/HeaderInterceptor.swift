//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import ReactiveNetwork

class HeaderInterceptor: RequestInterceptor {
    func intercept(request: URLRequest) -> URLRequest {
        var newRequest = request
        newRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        newRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return newRequest
    }
}
