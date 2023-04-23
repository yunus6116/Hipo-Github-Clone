//
//  UIHelper.swift
//  GitHubClone
//
//  Created by Yunus Kara on 23.04.2023.
//

import UIKit

enum UIHelper {
    static func createRepositoriesFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth = CGFloat.dWidth
        let itemHeight = CGFloat.dHeight * 0.07
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth-30, height: itemHeight)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
        
        return layout
    }
}
