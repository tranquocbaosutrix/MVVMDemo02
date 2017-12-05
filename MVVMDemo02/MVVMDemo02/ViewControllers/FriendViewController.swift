//
//  FriendViewController.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import UIKit
import PKHUD

class FriendViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var textFieldFirstname: UITextField! {
        didSet {
            textFieldFirstname.delegate = self
            textFieldFirstname.addTarget(self, action: #selector(firstnameTextFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var textFieldLastname: UITextField! {
        didSet {
            textFieldLastname.delegate = self
            textFieldLastname.addTarget(self, action: #selector(lastnameTextFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var textFieldPhonenumber: UITextField! {
        didSet {
            textFieldPhonenumber.delegate =  self
            textFieldPhonenumber.addTarget(self, action: #selector(phonenumberTextFieldDidChange), for: .editingChanged)
        }
    }
    @IBOutlet weak var buttonSubmit: UIButton!
    
    // MARK: Properties
    var updateFriends: (() -> Void)?
    var viewModel: FriendViewModel?
    
    fileprivate var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    // MARK: Methods
    @objc func firstnameTextFieldDidChange(textField: UITextField) {
        viewModel?.firstname = textField.text ?? ""
    }
    @objc func lastnameTextFieldDidChange(textField: UITextField) {
        viewModel?.lastname = textField.text ?? ""
    }
    @objc func phonenumberTextFieldDidChange(textField: UITextField) {
        viewModel?.phonenumber = textField.text ?? ""
    }
    func bindViewModel() {
        title = viewModel?.title
        textFieldFirstname?.text = viewModel?.firstname ?? ""
        textFieldLastname?.text = viewModel?.lastname ?? ""
        textFieldPhonenumber?.text = viewModel?.phonenumber ?? ""
        
        viewModel?.showLoadingHud.bind {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            $0 ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }
        
        viewModel?.updateSubmitButtonState = { [weak self] state in
            self?.buttonSubmit?.isEnabled = state
        }
        
        viewModel?.navigateBack = { [weak self] in
            self?.updateFriends?()
            let _ = self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel?.onShowError = { [weak self] alert in
            let alertController = UIAlertController(
                title: alert.title,
                message: alert.message,
                preferredStyle: .alert)
            alertController.addAction(UIAlertAction(
                title: alert.action.buttonTitle,
                style: .default,
                handler: { _ in
                    alert.action.handler?()
            }))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: Actions
extension FriendViewController {
    @IBAction func rootViewTapped(_ sender: Any) {
        activeTextField?.resignFirstResponder()
    }
    @IBAction func submitButtonTapp(_ sender: Any) {
        viewModel?.submitFriend()
    }
}

// MARK: UITextFieldDelegate
extension FriendViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
