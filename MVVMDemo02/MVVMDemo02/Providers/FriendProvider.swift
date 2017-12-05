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
    case postNewFriend([String: Any])
    case updateFriend(Int, [String: Any])
    case deleteFriend(Int)
}

extension FriendProvider: TargetType {
    public var baseURL: URL {
        return URL(string: LocalAPIConstants.BaseURL)!
    }
    
    public var path: String {
        switch self {
        case .getFriendList:
            return "/listFriends"
        case .postNewFriend:
            return "/addFriend"
        case .updateFriend(let id, _):
            return "/editFriend/\(id)"
        case .deleteFriend(let id):
            return "/editFriend/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getFriendList:
            return .get
        case .postNewFriend:
            return .post
        case .updateFriend:
            return .patch
        case .deleteFriend:
            return .delete
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .getFriendList:
            return "{{\"firstname\": \"Sylvester\", \"id\": \"22\"}}".utf8Encoded
        case .postNewFriend:
            return "{\"firstname\": \"Sutrix\", \"lastname\": \"Solutions\"}".utf8Encoded
        case .updateFriend:
            return "{\"firstname\": \"Sutrix\", \"lastname\": \"Solutions\"}".utf8Encoded
        case .deleteFriend:
            return "{}".utf8Encoded
        }
    }
    
    public var task: Task {
        switch self {
        case .getFriendList:
            return .requestPlain
        case .postNewFriend(let body):
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        case .updateFriend(_, let body):
            return .requestParameters(parameters: body, encoding: JSONEncoding.default)
        case .deleteFriend:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [LocalAPIConstants.HeaderParams.ContentType: LocalAPIConstants.HeaderParams.ContentTypeValue]
    }
}
