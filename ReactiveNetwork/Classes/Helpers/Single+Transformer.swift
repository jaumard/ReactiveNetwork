//
// Created by Jimmy Aumard on 14.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import RxSwift

extension Single {
    public func asCompletable() -> Completable {
        return self.asObservable().ignoreElements()
    }

    public func asMaybe() -> Maybe<Element> {
        return self.asObservable().asMaybe()
    }
}