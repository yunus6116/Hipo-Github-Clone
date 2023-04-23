//
//  String+Ext.swift
//  GitHubClone
//
//  Created by Yunus Kara on 22.04.2023.
//

import Foundation


extension String {
    func countOccurrences(of character: Character) -> Int {
        var count = 0
        for char in self {
            if char == character {
                count += 1
            }
        }
        return count
    }
}
