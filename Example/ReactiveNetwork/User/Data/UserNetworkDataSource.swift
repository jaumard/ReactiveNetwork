//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class UserNetworkDataSource: NetworkDataSource<User> {
    init(_ reactiveNetwork: ReactiveNetwork) {
        super.init("users", reactiveNetwork: reactiveNetwork)
    }
}
