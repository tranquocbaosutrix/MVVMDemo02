//
//  Result.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/4/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//

enum EmptyResult<U> where U: Error {
    case success
    case failure(U?)
}
