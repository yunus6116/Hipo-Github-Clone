//
//  UserDetailViewController.swift
//  GitHubClone
//
//  Created by Yunus Kara on 15.04.2023.
//

import UIKit

class MemberDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User
    
    var repositories: [Repository]
    
    private var containerView: UIView!
    
    private var repositoriesTitleView: UIView!
    
    private var collectionView: UICollectionView!
    
    private let width = CGFloat.dWidth
    private let height = CGFloat.dHeight

    
    // MARK: - Subviews
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = CGFloat.dHeight * 0.1 / 2
        return imageView
    }()
    
    let followersTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followingTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repositoriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    init(user: User, repositories: [Repository]) {
        self.user = user
        self.repositories = repositories
        super.init(nibName: nil, bundle: nil)
        title = user._name

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUserInfoSection()
        setUpRepositoriesTitleSection()
        setUpRepositoriesListSection()
    }
    
    private func setUpUserInfoSection() {
        followersTitleLabel.text = "Followers"
        followingTitleLabel.text = "Following"
        
        followersLabel.text = "\(user._followers)"
        followingLabel.text = "\(user._following)"
        repositoriesLabel.text = "Repositories"
        
        if let avatarUrl = user.avatarUrl, let imageUrl = URL(string: avatarUrl) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }.resume()
        }
        let followersStackView = UIStackView(arrangedSubviews:  [followersTitleLabel,followersLabel])
        followersStackView.axis = .vertical
        followersStackView.spacing = 4
        followersStackView.alignment = .center
        followersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let followingStackView = UIStackView(arrangedSubviews:  [followingTitleLabel,followingLabel])
        followingStackView.axis = .vertical
        followingStackView.alignment = .center
        followingStackView.spacing = 4
    
        followingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [followersStackView, followingStackView])
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView = UIView()
        containerView.backgroundColor = UIColor(red: 0.169, green: 0.192, blue: 0.216, alpha: 1.0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        containerView.addSubview(profileImageView)
        
        view.addSubview(containerView)
        let containerHeight = CGFloat.dHeight * 0.2

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: width),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight),
            
            profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: CGFloat.dHeight * 0.1),
            profileImageView.heightAnchor.constraint(equalToConstant: CGFloat.dHeight * 0.1),
            
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)

        ])
    }
    
    private func setUpRepositoriesTitleSection(){
        repositoriesTitleView = UIView()
        repositoriesTitleView.backgroundColor = UIColor(red: 0.176, green: 0.729, blue: 0.306, alpha: 1)
        repositoriesTitleView.translatesAutoresizingMaskIntoConstraints = false
        repositoriesTitleView.addSubview(repositoriesLabel)

        view.addSubview(repositoriesTitleView)
        
        let repositoriesHeight = CGFloat.dHeight * 0.05
        NSLayoutConstraint.activate([
            repositoriesLabel.centerXAnchor.constraint(equalTo: repositoriesTitleView.centerXAnchor),
            repositoriesLabel.centerYAnchor.constraint(equalTo: repositoriesTitleView.centerYAnchor),
            
            repositoriesTitleView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            repositoriesTitleView.widthAnchor.constraint(equalToConstant: width),
            repositoriesTitleView.heightAnchor.constraint(equalToConstant: repositoriesHeight)
        ])
    }
    
    private func setUpRepositoriesListSection() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createRepositoriesFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier: RepositoryCollectionViewCell.reuseId)
        
        // Extension
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: repositoriesTitleView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MemberDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCollectionViewCell.reuseId, for: indexPath) as! RepositoryCollectionViewCell
        cell.repo = repositories[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(repositories[indexPath.item]._language)
    }
}
