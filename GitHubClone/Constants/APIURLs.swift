//
//  APIURLs.swift
//  GitHubClone
//
//  Created by Yunus Kara on 22.04.2023.
//

import Foundation

enum APIURLs {
    static func userURL(userName: String) -> String {
        "https://api.github.com/users/\(userName)"
    }
    
    static func userRepositoriesURL(userName: String) -> String {
        "https://api.github.com/users/\(userName)/repos"
    }
}
