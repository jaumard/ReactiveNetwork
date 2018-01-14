//
// Created by Jimmy Aumard on 11.01.18.
// Copyright (c) 2018 jaumard. All rights reserved.
//

import RxSwift
import RxCocoa

public enum ReactiveNetworkError: Error {
    case invalidURL
    case encoding(error: Error)
    case decoding(error: Error)
    case networking(response: HTTPURLResponse)
}

public class ReactiveNetwork {
    private let baseUrl: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let requestInterceptors: Array<RequestInterceptor>
    private let responseInterceptors: Array<ResponseInterceptor>

    private init(baseUrl: String, requestInterceptors: Array<RequestInterceptor>, responseInterceptors: Array<ResponseInterceptor>) {
        self.baseUrl = baseUrl
        self.requestInterceptors = requestInterceptors;
        self.responseInterceptors = responseInterceptors;
    }

    private func doRequest(_ request: URLRequest) -> Single<Data> {
        return Single.just(request).map {
            (urlRequest: URLRequest) -> URLRequest in
            var finalRequest = urlRequest
            self.requestInterceptors.forEach({ (interceptor: RequestInterceptor) in
                finalRequest = interceptor.intercept(request: finalRequest)
            })
            return finalRequest
        }.flatMap {
            (urlRequest: URLRequest) -> Single<Data> in
            return self.doHTTPRequest(urlRequest)
        }
    }

    private func doHTTPRequest(_ request: URLRequest) -> Single<Data> {
        let responseJSON = URLSession.shared.rx.response(request: request)
        return responseJSON.flatMap {
            (response: HTTPURLResponse, data: Data) -> Single<Data> in
            var finalResponse = (response: response, data: data)
            self.responseInterceptors.forEach({ (interceptor: ResponseInterceptor) in
                finalResponse = interceptor.intercept(response: finalResponse.response, data: finalResponse.data)
            })
            if 200..<300 ~= finalResponse.response.statusCode {
                return Single.just(finalResponse.data)
            } else {
                return Single.error(ReactiveNetworkError.networking(response: finalResponse.response))
            }
        }.asSingle()
    }

    private func getRequest(method: String, path: String, queryParams: Dictionary<String, String>,
                            pathParams: Dictionary<String, String>,
                            headers: Dictionary<String, String>) -> Single<URLRequest> {
        var fullPath = path

        pathParams.forEach { key, value in
            fullPath = fullPath.replacingOccurrences(of: "{\(key)}", with: value)
        }

        guard var base = URLComponents(string: baseUrl) else {
            return Single.error(ReactiveNetworkError.invalidURL)
        }

        base.path = "\(base.path)\(fullPath)"

        let query = queryParams.map {
            URLQueryItem(name: $0, value: $1)
        }

        base.queryItems = query

        guard let url = base.url else {
            return Single.error(ReactiveNetworkError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return Single.just(request)
    }

    private func encode<T: Codable>(from: T) -> Single<Data> {
        do {
            let encoded = try self.encoder.encode(from)
            return Single.just(encoded)
        } catch {
            return Single.error(ReactiveNetworkError.encoding(error: error))
        }
    }

    private func decode<T: Decodable>(to: T.Type, data: Data) -> Single<T> {
        do {
            let encoded = try self.decoder.decode(to, from: data)
            return Single.just(encoded)
        } catch {
            return Single.error(ReactiveNetworkError.decoding(error: error))
        }
    }

    private func requestWithBody<T: Codable>(method: String,
                                             path: String,
                                             body: T,
                                             queryParams: Dictionary<String, String>,
                                             pathParams: Dictionary<String, String>,
                                             headers: Dictionary<String, String>) -> Single<Data> {
        return getRequest(method: method, path: path, queryParams: queryParams, pathParams: pathParams, headers: headers)
                .flatMap { request -> Single<Data> in
                    var mutableRequest = request
                    return self.encode(from: body).flatMap { data -> Single<Data> in
                        mutableRequest.httpBody = data
                        return self.doRequest(mutableRequest)
                    }
                }
    }

    private func requestWithoutBody(method: String,
                                    path: String,
                                    queryParams: Dictionary<String, String>,
                                    pathParams: Dictionary<String, String>,
                                    headers: Dictionary<String, String>) -> Single<Data> {
        return getRequest(method: method, path: path, queryParams: queryParams, pathParams: pathParams, headers: headers)
                .flatMap { request -> Single<Data> in
                    return self.doRequest(request)
                }
    }

    public func doRequest<T: Codable, R: Codable>(method: String = "POST",
                                                  path: String,
                                                  body: T,
                                                  queryParams: Dictionary<String, String> = [:],
                                                  pathParams: Dictionary<String, String> = [:],
                                                  headers: Dictionary<String, String> = [:]) -> Single<R> {
        return requestWithBody(method: method, path: path, body: body, queryParams: queryParams, pathParams: pathParams, headers: headers)
                .flatMap { data -> Single<R> in
                    self.decode(to: R.self, data: data)
                }
    }

    public func doRequest<T: Codable>(method: String = "POST",
                                      path: String,
                                      body: T,
                                      queryParams: Dictionary<String, String> = [:],
                                      pathParams: Dictionary<String, String> = [:],
                                      headers: Dictionary<String, String> = [:]) -> Completable {
        return requestWithBody(method: method, path: path, body: body, queryParams: queryParams, pathParams: pathParams, headers: headers)
                .asCompletable()
    }

    public func doRequest<T: Codable>(method: String = "GET",
                                      path: String,
                                      queryParams: Dictionary<String, String> = [:],
                                      pathParams: Dictionary<String, String> = [:],
                                      headers: Dictionary<String, String> = [:]) -> Single<T> {
        return requestWithoutBody(method: method, path: path, queryParams: queryParams, pathParams: pathParams, headers: headers)
                .flatMap { data -> Single<T> in
                    self.decode(to: T.self, data: data)
                }
    }

    public func doRequest(method: String = "DELETE",
                          path: String,
                          queryParams: Dictionary<String, String> = [:],
                          pathParams: Dictionary<String, String> = [:],
                          headers: Dictionary<String, String> = [:]) -> Completable {
        return requestWithoutBody(method: method, path: path, queryParams: queryParams, pathParams: pathParams, headers: headers).asCompletable()
    }

    public class Builder {
        let baseUrl: String
        var requestInterceptors: Array<RequestInterceptor> = []
        var responseInterceptors: Array<ResponseInterceptor> = []

        public init(baseUrl: String) {
            self.baseUrl = baseUrl
        }

        public func addInterceptor(interceptor: Interceptor) -> Builder {
            if interceptor is RequestInterceptor {
                requestInterceptors.append(interceptor as! RequestInterceptor)
            }
            if interceptor is ResponseInterceptor {
                responseInterceptors.append(interceptor as! ResponseInterceptor)
            }
            return self
        }

        public func withInterceptors(interceptors: Array<Interceptor>) -> Builder {
            interceptors.forEach { (interceptor: Interceptor) in
                _ = self.addInterceptor(interceptor: interceptor)
            }
            return self
        }

        public func build() -> ReactiveNetwork {
            return ReactiveNetwork(baseUrl: baseUrl, requestInterceptors: requestInterceptors, responseInterceptors: responseInterceptors)
        }
    }
}
