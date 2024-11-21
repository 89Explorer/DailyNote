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
        view.backgroundColor = .systemYellow
        
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
    
    
    /// 네비게이션바 설정하는 함수
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addFeedButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTappedAddButton))
        navigationItem.rightBarButtonItem = addFeedButton
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    // MARK: - Action
    /// 네비게이션바의 오른쪽 버튼을 누르면 ActionSheet를 호출하는 함수
    @objc private func didTappedAddButton() {
        let actionSheet = UIAlertController(title: "오늘 하루는 어땠나요? 😀", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "피드 작성하기", style: .default, handler: { action in
            print("피드를 작성합니다.")
            let feedVC = FeedViewController()
            self.navigationController?.pushViewController(feedVC, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true)
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
    
    // 테이블뷰의 높이를 자동적으로 추청하도록 하는 메서드
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
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
