//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import ReactiveNetwork
import RxSwift

class UserDetailsViewModel: BaseViewModel {
    let posts: Dynamic<[Post]> = Dynamic([])
    let user: User

    let postRepository: PostRepository

    init(_ user: User, postRepository: PostRepository) {
        self.postRepository = postRepository
        self.user = user
    }

    override func bind() {
        super.bind()
        self.loading.value = true
        postRepository.retrieveAllForUser(user).subscribeOn(CurrentThreadScheduler.instance).observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { posts in
                    self.posts.value = posts
                    self.loading.value = false
                }, onError: { error in
                    self.loading.value = false
                    self.error.value = error
                })
                .disposed(by: bag)
    }

    func removePost(_ post: Post) {
        self.loading.value = true
        postRepository.delete(post.id!).subscribeOn(CurrentThreadScheduler.instance).observeOn(MainScheduler.instance)
                .subscribe(onCompleted: { () in
                    self.loading.value = false
                }, onError: { error in
                    self.loading.value = false
                    self.error.value = error
                })
                .disposed(by: bag)
    }
}
