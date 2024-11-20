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
        view.backgroundColor = .white
        
        //self.navigationController?.navigationBar.isHidden = true
        
        configureConstraints()
        configureTableView()
        setupNavigationBar()
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
        homeTable.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        // appearance.backgroundColor = .systemYellow // 배경을 노란색으로 설정
        // appearance.shadowColor = .clear      // 그림자 없애기
        
        // 그림자 제거하고 기존의 백그라운드 색상을 사용 (그림자를 제거하고 기존 배경색을 사용)
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        //navigationController?.navigationBar.isTranslucent = true
        //navigationController?.navigationBar.shadowImage = UIImage() // 밑줄 없애기
    }
}

// MARK: - Extension: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.imageCollectionView.delegate = self
        cell.imageCollectionView.dataSource = self
        
        return cell
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        guard let selectedImage = UIImage(named: "new") else { return UICollectionViewCell()}
        cell.configureUserImage(with: selectedImage)
        
        return cell
    }
}
