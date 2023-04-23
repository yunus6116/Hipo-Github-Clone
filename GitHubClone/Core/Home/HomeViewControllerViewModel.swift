//
//  HomeViewModel.swift
//  GitHubClone
//
//  Created by Yunus Kara on 22.04.2023.
//

import Foundation

protocol IHomeViewControllerViewModel{
    var view: IHomeViewController? { get set }
}

final class HomeViewControllerViewModel {
    weak var view: IHomeViewController?
    private let service = UserService()
    private let repositoriesService = RepositoriesService()
}

extension HomeViewControllerViewModel: IHomeViewControllerViewModel{
    func getMemberDetail(userName: String){
        service.getMemberDetail(userName: userName) { [weak self] user in
            guard let self = self else {return}
            guard let user = user else { return }
            
            repositoriesService.getUserRepositories(userName: userName) { [weak self] repositories in
                guard let self = self else {return}
                guard let repositories = repositories else { return }
                
                self.view?.navigateToDetailScreen(user: user, repositories: repositories)
            }
        }
        
    }
    
}
