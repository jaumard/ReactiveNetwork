//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import RxSwift

open class Repository<T: Codable> {
    let networkDataSource: NetworkDataSource<T>

    public init(_ networkDataSource: NetworkDataSource<T>) {
        self.networkDataSource = networkDataSource
    }

    public func retrieveAll() -> Single<[T]> {
        return networkDataSource.get()
    }

    public func retrieve(id: Int) -> Single<T> {
        return networkDataSource.get(id)
    }

    public func delete(_ id: Int) -> Completable {
        return networkDataSource.delete(id)
    }

    public func update(_ id: Int, item: T) -> Single<T> {
        return networkDataSource.update(id, item: item)
    }

    public func create(_ item: T) -> Single<T> {
        return networkDataSource.create(item)
    }
}
