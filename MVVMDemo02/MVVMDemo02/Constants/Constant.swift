//
//  Constant.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

struct LocalAPIConstants {
    // MARK: Header Params
    struct HeaderParams {
        // Content-Type
        static let ContentType: String = "Content-Type"
        // application/json
        static let ContentTypeValue: String = "application/json"
    }
    // MARK: FriendService BaseURL
    static let BaseURL: String = "https://friendservice.herokuapp.com"
}
