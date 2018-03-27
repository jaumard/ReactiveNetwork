//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel {
    let bag = DisposeBag()
    let loading: Dynamic<Bool> = Dynamic(false)
    let error: Dynamic<Error?> = Dynamic(nil)

    func bind() {
    }

}
