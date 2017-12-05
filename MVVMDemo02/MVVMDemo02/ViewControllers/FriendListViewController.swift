//
//  FriendListViewController.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import UIKit
import PKHUD

class FriendListViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var tableViewFriendList: UITableView!
    
    // MARK: Properties
    let viewModel: FriendsTableViewViewModel = FriendsTableViewViewModel()
    struct StoryBoard {
        static let friendTableViewCellIdentifier = "FriendCellIdentifier"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFriends()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK Methods
    func bindViewModel() {
        viewModel.friendCells.bindAndFire() { [weak self] _ in
            self?.tableViewFriendList.reloadData()
        }
        
        viewModel.showLoadingHud.bind { visible in
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }
    }

}

extension FriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friendCells.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.friendCells.value[indexPath.row] {
        case .normal(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.friendTableViewCellIdentifier, for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
            cell.viewModel = viewModel
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.textLabel?.text = "No data available"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Wanna delete")
        }
    }
}

extension FriendListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsToAddFriend" {
            if let destinationViewController = segue.destination as? FriendViewController {
                destinationViewController.viewModel = AddFriendViewModel()
                destinationViewController.updateFriends = { [weak self] in
                    self?.viewModel.getFriends()
                }
            }
        }
        if segue.identifier == "friendsToUpdateFriend" {
            if let destinationViewController = segue.destination as? FriendViewController {
                if let indexPath = tableViewFriendList.indexPathForSelectedRow {
                    switch viewModel.friendCells.value[indexPath.row] {
                    case .normal(let viewModel):
                        destinationViewController.viewModel = UpdateFriendViewModel(friend: viewModel.friendItem)
                        destinationViewController.updateFriends = { [weak self] in
                            self?.viewModel.getFriends()
                        }
                    case .empty, .error:
                        break
                    }
                }
            }
        }
    }
}
