//
//  FriendCellViewModel.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

protocol FriendCellViewModel {
    var friendItem: Friend { get }
    var fullName: String { get }
    var phoneNumberText: String { get }
}

extension Friend: FriendCellViewModel {
    var friendItem: Friend {
        return self
    }
    var fullName: String {
        return firstname + " " + lastname
    }
    var phoneNumberText: String {
        return phonenumber
    }
}

