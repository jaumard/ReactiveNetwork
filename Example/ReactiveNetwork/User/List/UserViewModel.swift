//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift

class UserViewModel: BaseViewModel {
    let users: Dynamic<[User]> = Dynamic([])
    let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository

    }

    override func bind() {
        super.bind()
        loading.value = true
        userRepository.retrieveAll().subscribeOn(CurrentThreadScheduler.instance).observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { users in
                    self.users.value = users
                    self.loading.value = false
                }, onError: { error in
                    self.loading.value = false
                    self.error.value = error
                })
                .disposed(by: bag)
    }

    func removeUser(_ user: User) {
        loading.value = true
        userRepository.delete(user.id).subscribeOn(CurrentThreadScheduler.instance).observeOn(MainScheduler.instance)
                .subscribe(onCompleted: { () in
                    self.loading.value = false
                }, onError: { error in
                    self.loading.value = false
                    self.error.value = error
                })
                .disposed(by: bag)
    }
}