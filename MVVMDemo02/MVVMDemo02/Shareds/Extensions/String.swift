//
//  String.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation

extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
