//
//  FriendDataProvider.swift
//  MVVMDemo02
//
//  Created by Tran Quoc Bao on 12/1/17.
//  Copyright © 2017 Tran Quoc Bao. All rights reserved.
//
import Foundation
import Moya
import Alamofire

final class FriendDataProvider {
    
    // MARK: Can't init is singleton
    private init() {}
    
    // MARK: Shared Instance
    static let shared = FriendDataProvider()
    
    // MARK: Properties
    // MARK: GetFriends
    typealias GetFriendsResult = Result<[Friend]>
    typealias GetFriendsCompletion = (_ result: GetFriendsResult) -> Void
    // MARK: PostNewFriend
    typealias PostNewFriendResult = Result<Bool>
    typealias PostNewFriendCompletion = (_ result: PostNewFriendResult) -> Void
    // MARK: UpdateFriend
    typealias UpdateFriendResult = Result<Bool>
    typealias UpdateFriendCompletion = (_ result: UpdateFriendResult) -> Void
    // MARK: DeleteFriend
    typealias DeleteFriendResult = Result<Bool>
    typealias DeleteFriendCompletion = (_ result: DeleteFriendResult) -> Void
    
    // MARK: Methods
    func getFriendList(completion: @escaping GetFriendsCompletion) {
        let provider = MoyaProvider<FriendProvider>()
        provider.request(.getFriendList()) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let friendList = try JSONDecoder().decode([Friend].self, from: moyaResponse.data)
                    completion(.success(friendList))
                    // Test case: No data available
                    //completion(.success([Friend]()))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postNewFriend(firstname: String, lastname: String, phonenumber: String, completion: @escaping PostNewFriendCompletion) {
        let param = [
            "firstname": firstname,
            "lastname": lastname,
            "phonenumber": phonenumber
        ]
        let provider = MoyaProvider<FriendProvider>()
        provider.request(.postNewFriend(param)) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func updateFriend(id: Int, firstname: String, lastname: String, phonenumber: String, completion: @escaping UpdateFriendCompletion) {
        let param = [
            "firstname": firstname,
            "lastname": lastname,
            "phonenumber": phonenumber
        ]
        let provider = MoyaProvider<FriendProvider>()
        provider.request(.updateFriend(id, param)) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let friendInfoUpdated = try JSONDecoder().decode(Friend.self, from: moyaResponse.data)
                    if friendInfoUpdated.lastname != "" {
                        completion(.success(true))
                    }
                } catch let error {
                    completion(.failure(error))
                }
                completion(.success(false))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func deleteFriend(id: Int, completion: @escaping DeleteFriendCompletion) {
        let provider = MoyaProvider<FriendProvider>()
        provider.request(.deleteFriend(id)) { result in
            switch result {
            case .success(let moyaResponse):
                if let data = String(data: moyaResponse.data, encoding: .utf8) {
                    print(data)
                }
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
