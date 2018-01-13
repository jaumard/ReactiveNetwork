//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import UIKit
import ReactiveNetwork

extension UIViewController {
    func getReactiveNetwork() -> ReactiveNetwork {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.reactiveNetwork
    }

    func showErrorPopup(error: Error?) {
        let alert = UIAlertController(title: "Error", message: "An error occurred, please try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showLoading(state: Bool) {

    }
}
