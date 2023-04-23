//
//  User.swift
//  GitHubClone
//
//  Created by Yunus Kara on 15.04.2023.
//

import Foundation

struct Member: Codable {
    let name: String
    let github: String
    let hipo: HipoModel
}
