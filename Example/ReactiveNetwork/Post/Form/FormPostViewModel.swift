//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import RxSwift

class FormPostViewModel: BaseViewModel {
    let post: Post?
    let user: User
    let formSaved = Dynamic(false)
    let postRepository: PostRepository

    init(_ postRepository: PostRepository, user: User, post: Post?) {
        self.postRepository = postRepository
        self.user = user
        self.post = post
    }

    func savePost(title: String, body: String) {
        loading.value = true
        var single: Single<Post>
        if let p = self.post {
            single = postRepository.update(p.id!, item: Post(id: p.id, userId: p.userId, title: title, body: body))
        } else {
            single = postRepository.create(Post(id: nil, userId: user.id, title: title, body: body))
        }

        single.subscribeOn(CurrentThreadScheduler.instance).observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { post in
                    self.loading.value = false
                    self.formSaved.value = true
                }, onError: { error in
                    self.loading.value = false
                    self.error.value = error
                })
                .disposed(by: bag)
    }
}