//
//  Alert.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/4/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
