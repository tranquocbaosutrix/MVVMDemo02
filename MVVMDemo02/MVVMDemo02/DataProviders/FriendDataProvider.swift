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
}
