//
//  FriendTableViewCell.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import UIKit

class FriendTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    var viewModel: FriendCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        labelFullName.text = viewModel?.fullName
        labelPhoneNumber.text = viewModel?.phoneNumberText
    }

}
