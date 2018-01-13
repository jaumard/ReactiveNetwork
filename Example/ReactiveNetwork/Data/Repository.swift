//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import RxSwift

class Repository<T: Codable> {
    let networkDataSource: NetworkDataSource<T>

    init(_ networkDataSource: NetworkDataSource<T>) {
        self.networkDataSource = networkDataSource
    }

    func retrieveAll() -> Single<[T]> {
        return networkDataSource.get()
    }

    func retrieve(id: Int) -> Single<T> {
        return networkDataSource.get(id)
    }

    func delete(_ id: Int) -> Completable {
        return networkDataSource.delete(id)
    }

    func update(_ id: Int, item: T) -> Single<T> {
        return networkDataSource.update(id, item: item)
    }

    func create(_ item: T) -> Single<T> {
        return networkDataSource.create(item)
    }
}