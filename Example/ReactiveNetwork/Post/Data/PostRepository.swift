//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class PostRepository: Repository<Post> {
    let networkDataSource: PostNetworkDataSource
    init(_ networkDataSource: PostNetworkDataSource) {
        self.networkDataSource = networkDataSource
        super.init(networkDataSource)
    }

    func retrieveAllForUser(_ user: User) -> Single<[Post]> {
        return networkDataSource.retrieveAllForUser(user)
    }

}
