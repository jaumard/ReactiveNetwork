//
// Created by Jimmy Aumard on 11.01.18.
// Copyright (c) 2018 jaumard. All rights reserved.
//

import Foundation

public protocol Interceptor {
}

public protocol RequestInterceptor: Interceptor {
    func intercept(request: URLRequest) -> URLRequest
}

public protocol ResponseInterceptor: Interceptor {
    func intercept(response: HTTPURLResponse, data: Data) -> (response: HTTPURLResponse, data: Data)
}
