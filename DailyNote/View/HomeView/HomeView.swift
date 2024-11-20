//
//  HomeView.swift
//  DailyNote
//
//  Created by 권정근 on 11/20/24.
//

import UIKit

class HomeView: UIView {
    
    // MARK: - UI Components
    /// 배경이 되는 뷰
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 사용자의 피드를 보여주는 테이블뷰
    let homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(homeTableView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        homeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            homeTableView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            homeTableView.topAnchor.constraint(equalTo: basicView.topAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
            
        ])
    }
}
