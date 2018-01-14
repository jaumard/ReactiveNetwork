//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import RxSwift

open class NetworkDataSource<T: Codable> {
    private let reactiveNetwork: ReactiveNetwork
    private let basePath: String

    public init(_ basePath: String, reactiveNetwork: ReactiveNetwork) {
        self.reactiveNetwork = reactiveNetwork
        self.basePath = basePath
    }

    public func get() -> Single<[T]> {
        return reactiveNetwork.doRequest(method: "GET", path: self.basePath)
    }

    public func get(_ id: Int) -> Single<T> {
        return reactiveNetwork.doRequest(method: "GET", path: "\(self.basePath)/\(id)")
    }

    public func create(_ item: T) -> Single<T> {
        return reactiveNetwork.doRequest(method: "POST", path: self.basePath, body: item)
    }

    public func update(_ id: Int, item: T) -> Single<T> {
        return reactiveNetwork.doRequest(method: "PUT", path: "\(self.basePath)/\(id)", body: item)
    }

    public func delete(_ id: Int) -> Completable {
        return reactiveNetwork.doRequest(method: "DELETE", path: "\(self.basePath)/\(id)").asCompletable()
    }
}
