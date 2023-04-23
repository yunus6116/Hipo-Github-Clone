//
//  RepositoriesService.swift
//  GitHubClone
//
//  Created by Yunus Kara on 23.04.2023.
//

import Foundation

final class RepositoriesService {
    func getUserRepositories(userName: String, completion: @escaping ([Repository]?) ->()){
        guard let url = URL(string: APIURLs.userRepositoriesURL(userName: userName)) else {return}
        
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
    
    private func handleWithData(_ data: Data) -> [Repository]? {
        do {
            let repositories = try JSONDecoder().decode([Repository].self, from: data)
            return repositories
        } catch  {
            print(error)
            return nil
        }
    }
}
