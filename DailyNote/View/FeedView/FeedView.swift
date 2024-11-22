//
//  FeedView.swift
//  DailyNote
//
//  Created by 권정근 on 11/21/24.
//

import UIKit

class FeedView: UIView {
    
    // MARK: - UI Components
    
    /// 배경이 되는 뷰
    let basicView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .secondarySystemBackground
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    /// 제목을 작성할 수 있는 텍스트뷰
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.text = "오늘 하루는 어땠나요?😀 (20자 이내)"
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 5
        textView.textAlignment = .left
        textView.textContainer.maximumNumberOfLines = 1
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.label.cgColor
        textView.textColor = .secondaryLabel
        textView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return textView
    }()
    
    /// 작성한 날짜를 받는 라벨
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024년 12월 1일 PM 09:00"
        label.backgroundColor = .systemBackground
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.label.cgColor
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    /// 내용을 작성할 수 있는 텍스트뷰
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "오늘 하루 고생했어요. 당신의 하루를 들려주세요 ❤️"
        textView.backgroundColor = .systemBackground
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.label.cgColor
        textView.textColor = .secondaryLabel
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemOrange
        
        configureTextView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(titleTextView)
        basicView.addSubview(dateLabel)
        basicView.addSubview(contentTextView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleTextView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            titleTextView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            titleTextView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 10),
            titleTextView.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10),
            dateLabel.widthAnchor.constraint(equalToConstant: 220),
            dateLabel.heightAnchor.constraint(equalToConstant: 35),
            
            contentTextView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            contentTextView.heightAnchor.constraint(equalToConstant: 350),
            
            
        ])
    }
    
    // MARK: - Functions
    /// textView 관련 델리게이트 설정하는 함수
    func configureTextView() {
        titleTextView.delegate = nil
        contentTextView.delegate = nil
    }
    
    /// titleTextView를 반환하는 함수
    func calledTitleTextView() -> UITextView {
        return titleTextView
    }
    
    /// contentView를 반환하는 함수
    func calledContentTextView() -> UITextView {
        return contentTextView
    }
    
}
