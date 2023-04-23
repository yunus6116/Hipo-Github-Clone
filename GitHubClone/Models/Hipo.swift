//
//  Hipo.swift
//  GitHubClone
//
//  Created by Yunus Kara on 15.04.2023.
//

import Foundation

struct HipoModel: Codable {
    let position: String
    let yearsInHipo: Int
    
    enum CodingKeys: String, CodingKey {
        case position
        case yearsInHipo = "years_in_hipo"
    }
}
