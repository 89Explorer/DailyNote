//
//  FeedView.swift
//  DailyNote
//
//  Created by 권정근 on 11/21/24.
//

import UIKit

class FeedView: UIView {
    
    // MARK: - Variables
    weak var delegate: FeedViewDelegate?
    var imageCounts: Int = 0
    
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
    
    /// 이미지를 선택할 수 있는 버튼
    let selectedButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemOrange
        configuration.baseForegroundColor = .label
        
        configuration.title = "사진 추가"
        configuration.titleAlignment = .center
        configuration.subtitle = ""
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        configuration.attributedSubtitle?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        configuration.preferredSymbolConfigurationForImage = imageConfig
        configuration.image = UIImage(systemName: "photo.badge.plus")
        configuration.imagePadding = 10
        configuration.imagePlacement = .top
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    /// 선택한 이미지를 보여주는 컬렉션뷰
    let selectedImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemOrange
        
        configureConstraints()
        configureTextView()
        configureCollectionView()
        
        selectedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        selectedButton.subtitleLabel?.text = "\(self.imageCounts) / 5"
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
        basicView.addSubview(selectedButton)
        basicView.addSubview(selectedImageCollectionView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        selectedButton.translatesAutoresizingMaskIntoConstraints = false
        selectedImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
            contentTextView.heightAnchor.constraint(equalToConstant: 400),
            
            selectedButton.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            selectedButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            selectedButton.bottomAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            selectedButton.widthAnchor.constraint(equalToConstant: 100),
            
            selectedImageCollectionView.leadingAnchor.constraint(equalTo: selectedButton.trailingAnchor, constant: 10),
            selectedImageCollectionView.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 20),
            selectedImageCollectionView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            selectedImageCollectionView.bottomAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
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
    
    /// selectedImageCollectionView 관련 델리게이트 설정하는 함수
    func configureCollectionView() {
        selectedImageCollectionView.delegate = nil
        selectedImageCollectionView.dataSource = nil
    }
    
    /// 이미지 선택하는 버튼 아래에 SubTitle 설정하는 함수 
    func updateButtonSubtitle() {
        var updatedConfig = selectedButton.configuration
        updatedConfig?.subtitle = "\(self.imageCounts) / 5"
        selectedButton.configuration = updatedConfig
    }
    
    // MARK: - Action
    @objc private func buttonTapped() {
        delegate?.didTapSelectedImageButton()
    }
}


// MARK: - Protocol FeedViewDelegate
/// FeedView에서 발생하는 이벤트를 FeedViewController로 전달하는 역할
protocol FeedViewDelegate: AnyObject {
    func didTapSelectedImageButton()
}
