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
    /// 사용자가 선택한 이미지를 저장하는 배열
    //var selectedImages: [UIImage?] = [UIImage(named: "new"), UIImage(named: "Stroll"), UIImage(named: "Tastes") ]
    var selectedImages: [UIImage] = []
    var selectedImagesCount: Int = 0
    var selectedMaxImage: Int = 5
    
    // HomeViewController의 테이블로 부터 받은 데이터를 저장하는 프로퍼티
    var selectedFeedItem: FeedManager?
    var isEditable: Bool = false    // 수정 모드
    
    var feedStorageManager = FeedStorageManager()
    
    
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

        feedView.delegate = self
        
        if let _ = selectedFeedItem {
            configureUI()
            setupNavigationBar(isEditMode: false)
        } else {
            setupNavigationBar(isEditMode: true)
        }
    }
    
    init(feedItem: FeedManager? = nil) {
        self.selectedFeedItem = feedItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    /// 이미자가 추가될 때마다 업데이트 되는 함수
    func updateUIAfterImageSelection() {
        feedView.imageCounts = selectedImagesCount
        feedView.updateButtonSubtitle()
        feedView.selectedImageCollectionView.reloadData()
    }
    
    /// 경고창을 재사용할 수 있는 함수
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    /// 사용자가 작성한 피드를 저장하는 함수
    func savedFeedItem(feed: Feed, image: [UIImage]) {
        
        // FeedManager를 사용해 새로운 피드 작성
        let feedManager = FeedManager(feed: feed)
        
        // PHPPicker로 선택된 이미지를 저장하고 경로 생성
        let imagePaths = FeedStorageManager().saveImages(images: image, feedID: feedManager.id.uuidString)
        
        // 이미지 경로를 포함한 새로운 Feed 생성
        let updatedFeed = Feed(
            title: feed.title,
            contents: feed.contents,
            date: feed.date,
            imagePath: imagePaths
        )
        
        // FeedManager 업데이트
        let updatedFeedManager = FeedManager(id: feedManager.id, feed: updatedFeed)
        
        // Core Data에 저장
        FeedCoreDataManager().saveFeedItem(feedItem: updatedFeedManager)
        print("Feed saved successfully with ID: \(updatedFeedManager.id)")
    }
    
    ///  FeedViewController가 초기화 될때 받아온 데이터로 UI 구성하는 함수
    func configureUI() {
        guard let feedItem = selectedFeedItem else { return }
        
        feedView.titleTextView.text = feedItem.feed.title
        feedView.contentTextView.text = feedItem.feed.contents
        feedView.titleTextView.isEditable = false
        feedView.contentTextView.isEditable = false
        feedView.selectedButton.isEnabled = false
        feedView.selectedButton.alpha = 0.5
        
    }
    
    /// 네비게이션바 버튼 설정하는 함수
    func setupNavigationBar(isEditMode: Bool) {
        
        if isEditMode {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didAddFeed))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTappedSettings))
        }
    }
    
    func enableEditingMode() {
        feedView.titleTextView.isEditable = true
        feedView.contentTextView.isEditable = true
        feedView.selectedButton.isEnabled = true
        feedView.selectedButton.alpha = 1.0
        isEditable = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didFinishEditing))
    }
    
    
    // MARK: - Action
    /// 네비게이션바의 추가 버튼을 누를 경우 동작할 액션
    @objc func didAddFeed() {
        print("didAddFeed() called")
        
        let title = feedView.titleTextView.text
        let date = Date()
        let content = feedView.contentTextView.text
        
        let newFeed = Feed(
            title: title,
            contents: content,
            date: date,
            imagePath: []
        )
        
        let selectedImages = self.selectedImages
        savedFeedItem(feed: newFeed, image: selectedImages)
        navigationController?.popViewController(animated: true)
    }
    
    /// 네비게이션바 오른쪽 버튼(설정)을 누르면 동작하는 액션
    @objc func didTappedSettings() {
        let actionSheet = UIAlertController(title: "설정", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "수정", style: .default, handler: { _ in
            self.enableEditingMode()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deleteFeedItem()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil ))
        
        present(actionSheet, animated: true)
    }
    
    @objc private func didFinishEditing() {
        // 수정된 내용을 저장하는 로직
        guard let updatedTitle = feedView.titleTextView.text,
              let updatedContent = feedView.contentTextView.text,
              let currentFeedItem = selectedFeedItem else  { return }
        
        let updatedImages = selectedImages
        
        let updatedFeed = Feed(
            title: updatedTitle,
            contents: updatedContent,
            date: currentFeedItem.feed.date,
            imagePath: [])
        
        self.selectedImagesCount = currentFeedItem.feed.imagePath.count
        feedView.selectedImageCollectionView.reloadData()
        
        feedView.titleTextView.isEditable = false
        feedView.contentTextView.isEditable = false
        feedView.selectedButton.isEnabled = false
        feedView.selectedButton.alpha = 0.5
        isEditable = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTappedSettings))
        
        FeedCoreDataManager().updateFeedItem(feedID: currentFeedItem.id, updatedFeed: updatedFeed, newImages: updatedImages)
        
        // self.savedFeedItem(feed: updatedFeed, image: updatedImages)
    }
    
    func deleteFeedItem() {
        guard let feedItem = selectedFeedItem else { return }
        FeedStorageManager().deleteImages(from: feedItem.feed.imagePath)
        FeedCoreDataManager.shared.deleteFeedItems(feedItem: feedItem)
        navigationController?.popViewController(animated: true)
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
        
        if let feedItem = selectedFeedItem, !feedItem.feed.imagePath.isEmpty {
            return feedItem.feed.imagePath.count
        } else {
            return selectedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCollectionViewCell.identifier, for: indexPath) as? SelectedImageCollectionViewCell else { return UICollectionViewCell() }
        
        var images: [UIImage] = []

        if let feedItem = selectedFeedItem, !feedItem.feed.imagePath.isEmpty {
            // 기존 피드에서 이미지 경로를 로드
            images = FeedStorageManager().loadImages(from: feedItem.feed.imagePath)
        } else {
            // 새로운 피드 작성 모드에서 선택된 이미지를 사용
            images = self.selectedImages
        }

        // 이미지가 있는 경우 셀 구성
        if indexPath.item < images.count {
            cell.configureSelectedImage(with: images[indexPath.item])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 150
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

// MARK: - extension PHPickerViewControllerDelegate
extension FeedViewController: PHPickerViewControllerDelegate {
    
    /// 갤러리 창을 띄워 이미지를 선택할 수 있도록 해주는 함수
    private func presentImagePicker() {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])   // 이미지 선택 가능
        configuration.selection = .ordered    // 순서 보장
        configuration.preferredAssetRepresentationMode = .automatic  // 사용자가 선택한 이미지 또는 동영상 파일을 어떤 형태로 앱에 전달할지 결정
        
        // 선택 가능한 이미지 갯수 설정
        let remainingSelectionLimit = selectedMaxImage - selectedImagesCount
        
        if remainingSelectionLimit > 0 {
            configuration.selectionLimit = remainingSelectionLimit
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            showAlert(title: "알림", message: "선택할 수 있는 사진 수를 넘기셨어요 😅")
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for item in results {
            // itemProvider로 이미지를 로드
            item.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self else { return }
                
                if let image = image as? UIImage {
                    // 이미지를 로드한 경우
                    DispatchQueue.main.async {
                        self.selectedImages.append(image)
                        self.selectedImagesCount = self.selectedImages.count
                        self.updateUIAfterImageSelection()
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        self.showAlert(title: "에러", message: "이미지를 불러오는 데 실패했습니다: \(error.localizedDescription)")
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

// MARK: - extension FeedViewDelegate
extension FeedViewController: FeedViewDelegate {
    func didTapSelectedImageButton() {
        presentImagePicker()
    }
}
