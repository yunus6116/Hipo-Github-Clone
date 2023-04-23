//
//  MemberTableViewCell.swift
//  GitHubClone
//
//  Created by Yunus Kara on 15.04.2023.
//

import UIKit

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    static let reuseId = "MemberTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        imageView.tintColor = UIColor.label
        imageView.contentMode = .right
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func configureLayer() {
        layer.backgroundColor = UIColor(red: 0.98, green: 0.984, blue: 0.988, alpha: 1).cgColor
        layer.borderColor = UIColor(red: 0.911, green: 0.911, blue: 0.922, alpha: 1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = CGFloat(8)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(arrowImageView)
        contentView.addSubview(stackView)
        configureLayer()
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with member: Member) {
        nameLabel.text = member.name
    }
    
}

