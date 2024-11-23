//
//  FeedViewController.swift
//  DailyNote
//
//  Created by 권정근 on 11/21/24.
//

import UIKit
import PhotosUI

class FeedViewController: UIViewController {
    
    // MARK: - Variables
    var selectedImages: [UIImage?] = [UIImage(named: "new"), UIImage(named: "Stroll"), UIImage(named: "Tastes") ]
    
    // MARK: - UI Components
    /// 커스텀 뷰로 생성한 feedView
    let feedView: FeedView = {
        let feedView = FeedView()
        return feedView
    }()
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        
        configureConstraints()
        configureTextView()
        configureCollectionView()
        
        didTappedselectedButton()
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(feedView)
        
        feedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            feedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            feedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            
        ])
    }
    
    // MARK: - Functions
    /// textView 델리게이트를 선언하는 함수
    func configureTextView() {
        feedView.calledTitleTextView().delegate = self
        feedView.calledContentTextView().delegate = self
    }
    
    /// textView에 글자기 비어 있을 때 플레이스 홀더를 보여주고, 글자 색을 변경하는 함수
    func resetPlaceholder(for textView: UITextView, placeholder: String) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .secondaryLabel
        }
    }
    
    /// textView에 글자 색이 연한 색일 경우에 기존 text를 지우고 글자 색을 변경하는 함수
    func clearPlaceholder(for textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    /// collectionView 델리게이트를 선언하는 함수 
    func configureCollectionView() {
        feedView.selectedImageCollectionView.delegate = self
        feedView.selectedImageCollectionView.dataSource = self
        feedView.selectedImageCollectionView.register(SelectedImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectedImageCollectionViewCell.identifier)
    }
    
    /// 이미지 선택 버튼에 액션을 부여한 함수
    func didTappedselectedButton() {
        feedView.selectedButton.addTarget(self, action: #selector(didTappedSelectedImages), for: .touchUpInside)
    }
    
    // MARK: - Actions
    /// 이미지 선택 버튼을 누르면 동작하는 함수
    @objc private func didTappedSelectedImages() {
        print("didTappedSelectedImages - called()")
        
        // PHPickerConfiguration 설정
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5   // 선택 가능한 이미지 또는 영상 개수
        configuration.filter = .any(of: [.images])   // 이미지 선택 가능
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Extension UITextViewDelegate
extension FeedViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == feedView.calledTitleTextView() {
            clearPlaceholder(for: textView)
        } else if textView == feedView.calledContentTextView() {
            clearPlaceholder(for: textView)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == feedView.calledTitleTextView() {
            resetPlaceholder(for: textView, placeholder: "제목 쓰기 어렵다면 이모지로 표현해주세요 😉 ")
        } else if textView == feedView.calledContentTextView() {
            resetPlaceholder(for: textView, placeholder: "오늘 하루 무슨 일이 있으셨나요? 당신의 하루를 들려주세요 🥰")
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        /// 타이틀 텍스트뷰에 글자수 제한을 위한 변수 
        let maxTitleLength: Int = 20
        
        if textView == feedView.calledTitleTextView() {
            if feedView.calledTitleTextView().text.count > maxTitleLength {
                print("글자 수가 너무 길어요")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Extension UICollectionViewDelegate, UICollectionViewDataSource
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCollectionViewCell.identifier, for: indexPath) as? SelectedImageCollectionViewCell else { return UICollectionViewCell() }
        
        if let image = selectedImages[indexPath.row] {
            cell.configureSelectedImage(with: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 150
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}


extension FeedViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let imageItems = results.prefix(5)
        
        for item in imageItems {
            item.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        print("Selected image: \(image)")
                    }
                }
            }
        }
    }
}
