//
// Created by Jimmy Aumard on 13.01.18.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userDetailsView: UserDetailsView!
    private var posts = [Post]()

    var viewModel: UserDetailsViewModel?

    private func displayUI() {
        self.title = viewModel?.user.name
        if userDetailsView != nil {
            userDetailsView.emailLabel.text = viewModel?.user.email
            userDetailsView.usernameLabel.text = viewModel?.user.username
            userDetailsView.phoneLabel.text = viewModel?.user.phone
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let logButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        self.navigationItem.rightBarButtonItem = logButton
        displayUI()
        viewModel?.loading.bind { [unowned self] in
            self.showLoading(state: $0)
        }
        viewModel?.error.bind { [unowned self] in
            self.showErrorPopup(error: $0)
        }
        viewModel?.posts.bind { [unowned self] in
            self.posts = $0
            self.tableView.reloadData()
        }
        viewModel?.bind()
    }

    @objc func addNewPost() {
        performSegue(withIdentifier: "PostForm", sender: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            //handle delete
            self.viewModel?.removePost(self.posts[indexPath.row])
            self.posts.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            //handle edit
            self.performSegue(withIdentifier: "PostForm", sender: self.posts[indexPath.row])
        }

        return [deleteAction, editAction]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PostForm", sender: self.posts[indexPath.row])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostForm" {
            let destination = segue.destination as! FormPostViewController
            destination.viewModel = FormPostViewModel(PostRepository(PostNetworkDataSource(getReactiveNetwork())), user: viewModel!.user, post: sender as? Post)
        }
    }
}
