//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class UserRepository: Repository<User> {
    init(_ networkDataSource: UserNetworkDataSource) {
        super.init(networkDataSource)
    }
}