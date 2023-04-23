//
//  RepositoryCollectionViewCell.swift
//  GitHubClone
//
//  Created by Yunus Kara on 23.04.2023.
//

import UIKit

final class RepositoryCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let reuseId = "RepositoryCell"
    
    var repo: Repository? {
        didSet{
            guard let repo = repo else { return }
            repoNameLabel.text = repo._name
            repoCreatedDateLabel.text = repo._createdAt
            repoLanguageLabel.text = repo._language
            repoStarCountLabel.text = String(repo._stargazersCount)
            
            let dateString = repo._createdAt
            let dateFormatter = DateFormatter()
            let isoDateFormatter = ISO8601DateFormatter()
            
            
            if let date = isoDateFormatter.date(from: dateString) {
                // Set the output date format
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                let newDateString = dateFormatter.string(from: date)
                repoCreatedDateLabel.text = newDateString
            }
            
        }
    }
    
    // MARK: - Subviews
    
    let repoNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repoLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.176, green: 0.729, blue: 0.306, alpha: 1)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repoCreatedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repoStarCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10.0)))
        imageView.tintColor = UIColor(red: 0.176, green: 0.729, blue: 0.306, alpha: 1)
        return imageView
    }()
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    private func configureCell(){
        
        layer.cornerRadius = 8
        layer.borderColor = UIColor(red: 0.911, green: 0.911, blue: 0.922, alpha: 1).cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    
    private func setUpContent() {
        let nameAndCreatedDateStackView = UIStackView(arrangedSubviews:  [repoNameLabel, repoCreatedDateLabel])
        nameAndCreatedDateStackView.axis = .horizontal
        nameAndCreatedDateStackView.spacing = 10
        nameAndCreatedDateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let languageAndStarStackView = UIStackView(arrangedSubviews:  [repoLanguageLabel, starView, repoStarCountLabel])
        languageAndStarStackView.axis = .horizontal
        languageAndStarStackView.spacing = 4
        languageAndStarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let allInfoStackView = UIStackView(arrangedSubviews: [nameAndCreatedDateStackView, languageAndStarStackView])
        allInfoStackView.axis = .vertical
        allInfoStackView.spacing = 4
        allInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(allInfoStackView)
        
        NSLayoutConstraint.activate([
            allInfoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            allInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            allInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            allInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
        ])
        
    }
    
}
