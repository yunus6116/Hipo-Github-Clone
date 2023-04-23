//
//  Repository.swift
//  GitHubClone
//
//  Created by Yunus Kara on 23.04.2023.
//

import Foundation


struct Repository: Codable {
    let id: Int
    let name: String?
    let createdAt: String?
    let stargazersCount: Int?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, language
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
    }
    
    var _stargazersCount: Int {
        stargazersCount ?? 0
    }
    var _language: String {
        language ?? "N/A"
    }
    
    var _name: String {
        name ?? "Repository"
    }
    
    var _createdAt: String {
        createdAt ?? ""
    }
}
