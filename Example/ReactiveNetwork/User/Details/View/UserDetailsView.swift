//
//  UserDetailsView.swift
//  ReactiveNetwork_Example
//
//  Created by Jimmy Aumard on 13.01.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class UserDetailsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("UserDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
