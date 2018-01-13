//
//  ViewController.swift
//  ReactiveNetwork
//
//  Created by fa35de542d80347b4a3940d4945d1685503dec3d on 01/13/2018.
//  Copyright (c) 2018 fa35de542d80347b4a3940d4945d1685503dec3d. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    let userViewModel: UserViewModel
    var users = [User]()

    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        userViewModel = UserViewModel(userRepository: UserRepository(UserNetworkDataSource(appDelegate.reactiveNetwork)))
        super.init(coder: aDecoder)

        self.title = "BLOG"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].email
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            //handle delete
            self.userViewModel.removeUser(self.users[indexPath.row])
            self.users.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        return [deleteAction]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userViewModel.loading.bind { [unowned self] in
            self.showLoading(state: $0)
        }
        userViewModel.error.bind { [unowned self] in
            self.showErrorPopup(error: $0)
        }
        userViewModel.users.bind { [unowned self] in
            self.users = $0
            self.tableView.reloadData()
        }
        userViewModel.bind()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "UserDetails") {
            let viewController = segue.destination as! UserDetailsViewController
            viewController.viewModel = UserDetailsViewModel(users[self.tableView.indexPathForSelectedRow!.row], postRepository: PostRepository(PostNetworkDataSource(getReactiveNetwork())))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

