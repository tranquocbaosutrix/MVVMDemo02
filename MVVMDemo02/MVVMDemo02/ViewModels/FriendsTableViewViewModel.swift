//
//  FriendsTableViewViewModel.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

class FriendsTableViewViewModel {
    
    // MARK: Properties
    enum FriendsTableViewCellType {
        case normal(cellViewModel: FriendCellViewModel)
        case error(message: String)
        case empty
    }
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    var showLoadingHud: Bindable = Bindable(false)
    let friendCells = Bindable([FriendsTableViewCellType]())
    
    // MARK: Methods
    func getFriends() {
        showLoadingHud.value = true
        FriendDataProvider.shared.getFriendList { [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let friends):
                guard friends.count > 0 else {
                    self?.friendCells.value = [.empty]
                    return
                }
                self?.friendCells.value = friends.flatMap { .normal(cellViewModel: $0 as FriendCellViewModel)}
            case .failure(let error):
                self?.friendCells.value = [.error(message: error.localizedDescription)]
            }
        }
    }
    func deleteFriend(at index: Int) {
        switch friendCells.value[index] {
        case .normal(let viewModel):
            FriendDataProvider.shared.deleteFriend(id: viewModel.friendItem.id, completion: { [weak self] result in
                switch result {
                case .success(let response):
                    if response != false {
                        self?.getFriends()
                    }
                case .failure(let error):
                    let okAlert = SingleButtonAlert(
                        title: error.localizedDescription,
                        message: "Could not remove \(viewModel.fullName)",
                        action: AlertAction(buttonTitle: "OK", handler: {
                            print("OK pressed!")
                        }))
                    self?.onShowError?(okAlert)
                }
            })
        default:
            break
        }
    }
}
