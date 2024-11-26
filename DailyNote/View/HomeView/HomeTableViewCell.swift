//
//  HomeTableViewCell.swift
//  DailyNote
//
//  Created by 권정근 on 11/20/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "HomeTableViewCell"
    
    var imagePaths: [String] = []
    var imageFromPaths: [UIImage] = []
    
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
    
    /// 피드를 담아줄 스택뷰
    let tableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        //stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    /// 제목 라벨
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 아침에 커피 3잔을 마셨다."
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    /// 날짜 라벨
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "11월 14일 오전 9시"
        label.textColor = .label
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    /// 내용 라벨
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 너무 피곤했다. 그래서 커피를 아침부터 연거푸 3잔을 마셨다. 그래서인가 차가운 날씨 속에 내 심장만이 열일 한다."
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    /// 이미지를 보여줄 컬렉션뷰
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        
        configureConstraints()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(tableStackView)
        tableStackView.addArrangedSubview(mainTitleLabel)
        tableStackView.addArrangedSubview(dateLabel)
        tableStackView.addArrangedSubview(contentLabel)
        tableStackView.addArrangedSubview(imageCollectionView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        tableStackView.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            tableStackView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            tableStackView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            tableStackView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 10),
            tableStackView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10),
            
            contentLabel.heightAnchor.constraint(equalToConstant: 100),
            
            imageCollectionView.heightAnchor.constraint(equalToConstant: 180)
            
        ])
        
    }
    
    // MARK: - Functions
    /// ImageCollectionView에 대한 델리게이트, 데이터소스, 레지스트를 처리하는 함수
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    
    /// 사용자가 작성한 데이터를 홈 화면에 전달하는 함수
    func configureFeed(with feed: Feed) {
        let title = feed.title ?? ""
        let date = feed.date
        let contents = feed.contents ?? ""
    
        mainTitleLabel.text = title
        dateLabel.text = date?.formatted()
        contentLabel.text = contents
        
        reloadCollectionView()
    }
    
    /// 이미지 경로를 갖고 파일 매니저로부터 이미지를 불러오는 함수 
    func reloadCollectionView() {
        self.imageFromPaths = FeedStorageManager().loadImages(from: imagePaths)
        print("Reloading collection view with imagePaths: \(imagePaths)") // 추가
        imageCollectionView.reloadData()
    }
}


// MARK: Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFromPaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        let image = imageFromPaths[indexPath.item]
        cell.configureUserImage(with: image)
        return cell
    }
}
