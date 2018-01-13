//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import UIKit

class FormPostViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    var viewModel: FormPostViewModel?

    private func displayUI() {
        if let post = viewModel?.post {
            self.title = post.title
            self.titleField.text = post.title
            self.bodyField.text = post.body
        } else {
            self.title = "New post"
        }
    }

    @IBAction func savePost(_ sender: Any) {
        titleField.isEnabled = false
        saveButton.isEnabled = false
        bodyField.isEditable = false
        viewModel?.savePost(title: titleField.text!, body: bodyField.text!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayUI()

        viewModel?.error.bind {
            [unowned self] in
            self.showErrorPopup(error: $0)
            self.titleField.isEnabled = true
            self.saveButton.isEnabled = true
            self.bodyField.isEditable = true
        }

        viewModel?.formSaved.bind {
            [unowned self] in
            if $0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
