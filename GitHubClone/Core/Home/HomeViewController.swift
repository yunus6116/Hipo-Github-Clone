import UIKit

protocol IHomeViewController: AnyObject{
    func navigateToDetailScreen(user: User, repositories: [Repository])
}


class HomeViewController: UIViewController { 
    
    private let viewModel = HomeViewControllerViewModel()
    
    private var members = [Member]()
    private var filteredMembers = [Member]()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // UserDefaults instance
    let userDefaults = UserDefaults.standard
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var getAllObjects: [Member] {
          let defaultObject = Member(name: "", github: "", hipo: HipoModel(position: "", yearsInHipo: 0))
          if let objects = UserDefaults.standard.value(forKey: "members") as? Data {
             let decoder = JSONDecoder()
             if let objectsDecoded = try? decoder.decode([Member].self, from: objects) as [Member] {
                return objectsDecoded
             } else {
                return [defaultObject]
             }
          } else {
              let response: GetAllMembersResponse = try! JSONDecoder().decode(GetAllMembersResponse.self, from:AppConstants.jsonData)
              saveAllObjects(allObjects: response.members)
              return response.members
          }
       }

    func saveAllObjects(allObjects: [Member]) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(allObjects){
             UserDefaults.standard.set(encoded, forKey: "members")
          }
     }
    
    
    // Üyeleri geri getirme fonksiyonu
    func loadMembers() {
        members = getAllObjects
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        viewModel.view = self
        configureVC()
        setupTableView()
        setupSearchBar()
        setupButtons()
        loadMembers()
        
        tableView.reloadData()
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMember = isFiltering ? filteredMembers[indexPath.section] : members[indexPath.section]
        viewModel.getMemberDetailAndNavigate(userName: selectedMember.github)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: IHomeViewController{
    func navigateToDetailScreen(user: User, repositories: [Repository]) {
        DispatchQueue.main.async {
            let detailScreen = MemberDetailViewController(user: user, repositories: repositories)
            self.navigationController?.pushViewController(detailScreen, animated: true)
        }
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Members"
    }
    
}


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  isFiltering ? filteredMembers.count : members.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.reuseId, for: indexPath) as! MemberTableViewCell
        
        let member = isFiltering ? filteredMembers[indexPath.section] : members[indexPath.section]
        cell.configure(with: member)
        return cell
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filteredMembers = members.filter { member in
            let nameMatch = member.name.lowercased().contains(searchText.lowercased())
            let positionMatch = member.hipo.position.lowercased().contains(searchText.lowercased())
            return nameMatch || positionMatch
        }
        tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMembers = []
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
}

// MARK: - Setup UI

extension HomeViewController {
    
    private func setupTableView() {
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CGFloat.dHeight * 0.2)
        ])
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupButtons() {
        var sortConfiguration = UIButton.Configuration.filled()
        
        sortConfiguration.title = "SORT MEMBERS"
        sortConfiguration.baseBackgroundColor = UIColor(red: 0.169, green: 0.192, blue: 0.216, alpha: 1)
        sortConfiguration.background.cornerRadius = 40
        sortConfiguration.cornerStyle = .fixed
        sortConfiguration.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        
        let sortButton = UIButton(configuration: sortConfiguration, primaryAction: nil)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        var addConfiguration = UIButton.Configuration.filled()
        
        addConfiguration.title = "ADD NEW MEMBER"
        addConfiguration.baseBackgroundColor = UIColor(red: 0.176, green: 0.729, blue: 0.306, alpha: 1)
        addConfiguration.background.cornerRadius = 40
        addConfiguration.cornerStyle = .fixed
        addConfiguration.contentInsets = NSDirectionalEdgeInsets(
            top: 14,
            leading: 0,
            bottom: 14,
            trailing: 0
        )
        
        let addButton = UIButton(configuration: addConfiguration, primaryAction: nil)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [sortButton,addButton,])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func addButtonTapped() {
        let alert = UIAlertController(title: "Add", message: "First enter full name and then enter Github user name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "full name"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "user name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            guard let self = self, let alert = alert else { return }
            guard let fullname = alert.textFields?[0].text, !fullname.isEmpty else {
                let errorAlert = UIAlertController(title: "Error", message: "Please enter the full name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            guard let name = alert.textFields?[1].text, !name.isEmpty else {
                let errorAlert = UIAlertController(title: "Error", message: "Please enter the name", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            let newMember = Member(name: fullname, github: name, hipo: HipoModel(position: "", yearsInHipo: 0))
            if (members.contains(where: { member in
                member.github == newMember.github
            })) {
                let errorAlert = UIAlertController(title: "Error", message: "User already exists.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            self.members.append(newMember)
            saveAllObjects(allObjects: members)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func sortButtonTapped() {
        let sortedMembers = members.sorted { (member1, member2) -> Bool in
            let lastName1 = member1.name.components(separatedBy: " ").last ?? ""
            let lastName2 = member2.name.components(separatedBy: " ").last ?? ""
            let count1 = lastName1.countOccurrences(of: Character("a"))
            let count2 = lastName2.countOccurrences(of: Character("a"))
            
            if count1 == count2 {
                if lastName1.count == lastName2.count {
                    return lastName1.localizedCaseInsensitiveCompare(lastName2) == .orderedAscending
                } else {
                    return lastName1.count > lastName2.count
                }
            } else {
                return count1 > count2
            }
        }
        members = sortedMembers
        tableView.reloadData()
    }
    
}
