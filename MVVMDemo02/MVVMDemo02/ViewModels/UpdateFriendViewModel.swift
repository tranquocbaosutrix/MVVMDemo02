//
//  UpdateFriendViewModel.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

final class UpdateFriendViewModel: FriendViewModel {
    var friend: Friend
    var title: String {
        return "Update Friend"
    }
    
    var firstname: String? {
        didSet {
            validateInput()
        }
    }
    
    var lastname: String? {
        didSet {
            validateInput()
        }
    }
    
    var phonenumber: String? {
        didSet {
            validateInput()
        }
    }
    
    var validInputData: Bool = false {
        didSet {
            if oldValue != validInputData {
                updateSubmitButtonState?(validInputData)
            }
        }
    }
    
    let showLoadingHud = Bindable(false)
    
    var updateSubmitButtonState: ((Bool) -> ())?
    
    var navigateBack: (() -> ())?
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    init(friend: Friend) {
        self.friend = friend
        self.firstname = friend.firstname
        self.lastname = friend.lastname
        self.phonenumber = friend.phonenumber
    }
    
    func submitFriend() {
        guard let firstname = firstname, let lastname = lastname, let phonenumber = phonenumber else { return }
        
        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        FriendDataProvider.shared.updateFriend(id: friend.id, firstname: firstname, lastname: lastname, phonenumber: phonenumber) { [weak self] result in
            switch result {
            case .success(let response):
                if response != false {
                    self?.navigateBack?()
                }
            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error.localizedDescription,
                    message: "Failed to update information",
                    action: AlertAction(buttonTitle: "OK", handler: {
                        print("OK pressed!")
                    }))
                self?.onShowError?(okAlert)
            }
        }
    }
    
    func validateInput() {
        let validData = [firstname, lastname, phonenumber].filter {
            ($0?.count ?? 0) > 0
        }
        validInputData = (validData.count == 0) ? false : true
    }
}
