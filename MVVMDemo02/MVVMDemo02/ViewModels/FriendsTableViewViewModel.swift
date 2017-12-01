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
    
}
