//
//  FriendProvider.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Moya

public enum FriendProvider {
    case getFriendList()
}

extension FriendProvider: TargetType {
    public var baseURL: URL {
        return URL(string: LocalAPIConstants.BaseURL)!
    }
    
    public var path: String {
        switch self {
        case .getFriendList:
            return "/listFriends"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getFriendList:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getFriendList:
            return "{{\"firstname\": \"Sylvester\", \"id\": \"22\"}}".utf8Encoded
        }
    }
    
    public var task: Task {
        switch self {
        case .getFriendList:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
