//
// Created by Jimmy Aumard on 14.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

open class LogInterceptor: RequestInterceptor, ResponseInterceptor {
    let level: Level

    public enum Level {
        case debug
        case info
        case none
    }

    public init(level: Level = .info) {
        self.level = level
    }

    public func intercept(request: URLRequest) -> URLRequest {
        if level == .none {
            return request
        }
        print("REQUEST -> \(request.httpMethod!) \(request.url!)")

        if level == .debug {
            if let headers = request.allHTTPHeaderFields {
                var headersDesc = ""
                headers.forEach({ (key, value) in
                    headersDesc.append("\t\(key):\(value)\n")
                })
                print("headers:\n\(headersDesc)")
            }
            if let body = request.httpBody, let bodyStr = String(data: body, encoding: .utf8) {
                print("Body: \(bodyStr)")
            }
        }
        return request
    }

    public func intercept(response: HTTPURLResponse, data: Data) -> (response: HTTPURLResponse, data: Data) {
        if level == .none {
            return (response: response, data: data)
        }
        print("RESPONSE -> status: \(response.statusCode)")
        if level == .debug {
            let headers = response.allHeaderFields
            var headersDesc = ""
            headers.forEach({ (key, value) in
                headersDesc.append("\t\(key):\(value)\n")
            })
            print("headers:\n\(headersDesc)")

            if let bodyStr = String(data: data, encoding: .utf8) {
                print("Body: \(bodyStr)")
            }
        }
        return (response: response, data: data)
    }
}
