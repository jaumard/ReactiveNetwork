//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class PostRepository: Repository<Post> {

    init(_ networkDataSource: PostNetworkDataSource) {
        super.init(networkDataSource)
    }

    func retrieveAllForUser(_ user: User) -> Single<[Post]> {
        return (networkDataSource as! PostNetworkDataSource).retrieveAllForUser(user)
    }

}