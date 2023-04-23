//
//  User.swift
//  GitHubClone
//
//  Created by Yunus Kara on 22.04.2023.
//

import Foundation

struct User: Codable {
    let login: String
    let id: Int
    let avatarUrl: String?
    let reposUrl: String?
    let name: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login, id, name, followers, following
        case avatarUrl = "avatar_url"
        case reposUrl = "repos_url"
        case publicRepos = "public_repos"
    }
    
    var _name: String {
        name ?? "Github User Profile"
    }
    var _followers: Int {
        followers ?? 0
    }
    var _following: Int {
        following ?? 0
    }
    var _publicRepos: Int {
        publicRepos ?? 0
    }
}
