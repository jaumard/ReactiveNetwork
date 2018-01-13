//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class PostNetworkDataSource: NetworkDataSource<Post> {
    private let reactiveNetwork: ReactiveNetwork
    private let basePath = "posts"

    init(_ reactiveNetwork: ReactiveNetwork) {
        self.reactiveNetwork = reactiveNetwork
        super.init(basePath, reactiveNetwork: reactiveNetwork)
    }

    func retrieveAllForUser(_ user: User) -> Single<[Post]> {
        return reactiveNetwork.doRequest(method: "GET", path: "users/\(user.id)/posts")
    }
}
