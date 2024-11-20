//
//  HomeViewController.swift
//  DailyNote
//
//  Created by 권정근 on 11/20/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    let homeView: HomeView = {
        let homeView = HomeView()
        return homeView
    }()
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        configureConstraints()
        configureTableView()
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(homeView)
        
        homeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            homeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    // MARK: - Functions
    private func configureTableView() {
        let homeTable = homeView.homeTableView
        homeTable.delegate = self
        homeTable.dataSource = self
        homeTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "Test"
        return cell 
    }
}

