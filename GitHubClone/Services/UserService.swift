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
                self.handleWithError(error)
            }
        })
    }
    
    private func handleWithError(_ error: Error){
        print(error.localizedDescription)
    }
    
    private func handleWithData(_ data: Data) -> User? {
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch  {
            print(error)
            return nil
        }
    }
}
