//
//  HeaderInterceptor.swift
//  ReactiveNetwork
//
//  Created by Jimmy Aumard on 14.01.18.
//

import Foundation

open class HeaderInterceptor: RequestInterceptor {
    let headers: Dictionary<String, String>

    public init(_ headers: Dictionary<String, String>) {
        self.headers = headers
    }

    public func intercept(request: URLRequest) -> URLRequest {
        var newRequest = request
        self.headers.forEach { (key, value) in
            newRequest.addValue(value, forHTTPHeaderField: key)
        }
        return newRequest
    }
}
