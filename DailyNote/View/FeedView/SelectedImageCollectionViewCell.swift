//
//  SelectedImageCollectionViewCell.swift
//  DailyNote
//
//  Created by 권정근 on 11/23/24.
//

import UIKit

class SelectedImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "SelectedImageCollectionViewCell"
    
    // MARK: - UI Component
    /// 배경이 되는 뷰
    let basicView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    /// 선택된 이미지를 보여주는 이미지뷰
    let selectedImagView: UIImageView = {
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
        basicView.addSubview(selectedImagView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        selectedImagView.translatesAutoresizingMaskIntoConstraints = false 
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectedImagView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            selectedImagView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            selectedImagView.topAnchor.constraint(equalTo: basicView.topAnchor),
            selectedImagView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
            
        ])
    }
    
    // MARK: - Functions
    /// selectedImageView에 이미지를 전달하는 함수 
    func configureSelectedImage(with image: UIImage) {
        selectedImagView.image = image
    }
}
