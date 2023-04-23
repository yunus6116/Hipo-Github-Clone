//
//  GetAllUsersResponse.swift
//  GitHubClone
//
//  Created by Yunus Kara on 15.04.2023.
//

import Foundation

struct GetAllMembersResponse: Codable {
    let company: String
    let team: String
    let members: [Member]
}
