//
//  AddFriendViewModel.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

protocol FriendViewModel {
    var title: String { get }
    var firstname: String? { get set }
    var lastname: String? { get set }
    var phonenumber: String? { get set }
    var showLoadingHud: Bindable<Bool> { get }
    
    var updateSubmitButtonState: ((Bool) -> ())? { get set }
    var navigateBack: (() -> ())? { get set }
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)? { get set }
    
    func submitFriend()
}

final class AddFriendViewModel: FriendViewModel {

    var title: String {
        return "Add New Friend"
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
    
    var showLoadingHud: Bindable = Bindable(false)
    
    var updateSubmitButtonState: ((Bool) -> ())?
    
    var navigateBack: (() -> ())?
    
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    private var validInputData: Bool = false {
        didSet {
            if oldValue != validInputData {
                updateSubmitButtonState?(validInputData)
            }
        }
    }
    
    func submitFriend() {
        guard let firstname = firstname, let lastname = lastname, let phonenumber = phonenumber else { return }
        
        updateSubmitButtonState?(false)
        showLoadingHud.value = true
        
        FriendDataProvider.shared.postNewFriend(firstname: firstname, lastname: lastname, phonenumber: phonenumber) { [weak self] result in
            self?.showLoadingHud.value = false
            self?.updateSubmitButtonState?(true)
            switch result {
            case .success:
                self?.navigateBack?()
            case let .failure(error):
                let okAlert = SingleButtonAlert(
                    title: error.localizedDescription,
                    message: "Could not add firstname: \(firstname), lastname: \(lastname)",
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
