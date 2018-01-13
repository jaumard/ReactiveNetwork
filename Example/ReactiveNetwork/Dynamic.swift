//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}