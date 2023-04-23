//
//  UserServices.swift
//  GitHubClone
//
//  Created by Yunus Kara on 22.04.2023.
//

import Foundation

final class UserService {
    func getMemberDetail(userName: String, completion: @escaping (User?) ->()){
        guard let url = URL(string: APIURLs.userURL(userName: userName)) else {return}
        
        NetworkManager.shared.get(url: url, completion: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                completion(self.handleWithData(data))
            case .failure(let error):
                completion(self.handleWithError(error))
            }
        })
    }
    
    private func handleWithError(_ error: Error) -> User? {
        return User(login: "", id: -1, avatarUrl: "", reposUrl: "", name: "", publicRepos: 0, followers: 0, following: 0)
    }
    
    private func handleWithData(_ data: Data) -> User? {
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch  {
            return nil
        }
    }
}
