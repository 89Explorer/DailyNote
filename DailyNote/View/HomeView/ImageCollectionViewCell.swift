//
//  ImageCollectionViewCell.swift
//  DailyNote
//
//  Created by 권정근 on 11/21/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "ImageCollectionViewCell"
    
    // MARK: - UI Components
    /// 배경이 되는 뷰
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view 
    }()
    
    /// 사용자의 이미지를 보여주는 뷰
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        
        contentView.addSubview(basicView)
        basicView.addSubview(userImageView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            userImageView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            userImageView.topAnchor.constraint(equalTo: basicView.topAnchor),
            userImageView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
        ])
    }
    
    // MARK: - Functions
    /// 사용자가 선택한 이미지를 userImageView에 할당하는 함수
    func configureUserImage(with image: UIImage) {

        userImageView.image = image
    }
}
