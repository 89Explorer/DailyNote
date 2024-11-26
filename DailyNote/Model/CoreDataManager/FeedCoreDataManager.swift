//
//  FeedCoreDataManager.swift
//  DailyNote
//
//  Created by 권정근 on 11/25/24.
//

import Foundation
import UIKit
import CoreData


class FeedCoreDataManager {
    
    static let shared = FeedCoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let feedStorageManager = FeedStorageManager()
    
    
    /// 고유 ID를 기반으로 한 이미지 경로 매핑
    private(set) var imagePathsByID: [UUID: [String]] = [:]
    
    
    /// Feed 데이터를 Core Data에서 로드하고, ID 기반 이미지 매핑 초기화
    func initializeFeedData() -> [FeedManager] {
        let feedItems = loadFeedItem() // Core Data에서 Feed 데이터 불러오기
        imagePathsByID = [:] // 초기화
        
        for feed in feedItems {
            //imagePathsByID[feed.id] = feed.imagePath
        }
        return feedItems
    }
    
    
    /// 코어 데이터에 사용자가 작성한 내용 저장하는 메서드
    func saveFeedItem(feedItem: FeedManager) {
        let feedModel = FeedModel(context: context)
        
        // Feed의 데이터 설정
        feedModel.id = feedItem.id
        feedModel.title = feedItem.feed.title
        feedModel.date = feedItem.feed.date
        feedModel.content = feedItem.feed.contents
        
        // 여러 이미지 경로를 문자열로 저장 (쉼표로 구분)
        feedModel.imagePath = feedItem.feed.imagePath.isEmpty ? nil : feedItem.feed.imagePath.joined(separator: ",")
        
        // Core Data 저장
        do {
            try context.save()
            print("Feed item saved successfully.")
        } catch {
            print("Failed to save feed item: \(error)")
        }
        
    }
    
    /// feed 데이터를 불러오는 함수
    func loadFeedItem() -> [FeedManager] {
        let request: NSFetchRequest<FeedModel> = FeedModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        var feedItems: [FeedManager] = []
        
        do {
            let feedModels = try context.fetch(request)
            
            for entity in feedModels {
                guard let entityID = entity.id else {
                    print("Warning: Entity ID is missing. Skipping this feed.")
                    continue
                }
                
                // imagePath 문자열을 배열로 변환
                let imagePaths: [String] = entity.imagePath?.components(separatedBy: ",") ?? []
                
                // FeedManager 생성
                let feedItem = FeedManager(
                    id: entityID, // Core Data에서 저장한 ID 사용
                    feed: Feed(
                        title: entity.title,
                        contents: entity.content,
                        date: entity.date,
                        imagePath: imagePaths
                    )
                )

                feedItems.append(feedItem)
            }
        } catch {
            print("Failed to load feed items: \(error)")
        }
        
        return feedItems
    }
    
    
    ///  feed를 삭제하면서 동시에 filemnager에 저장된 이미지도 삭제하는 함수
    func deleteFeedItems(feedItem: FeedManager) {
        
        // 코어 데이터 불러오기
        let request: NSFetchRequest<FeedModel> = FeedModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", feedItem.id as CVarArg)
        request.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(request)
            if let feedToDelete = fetchResults.first {
                
                // 이미지 경로 삭제
                let imagePaths = feedToDelete.imagePath?.components(separatedBy: ",") ?? []
                FeedStorageManager().deleteImages(from: imagePaths)
                
                // 코어 데이터에서 삭제
                context.delete(feedToDelete)
                try context.save()
                print("Feed item and images deleted succeessfully")
            } else {
                print("Feed item not found in Core Data.")
            }
        } catch {
            print("Failed to delete feed item: \(error)")
        }
    }
    
    
    /// 사용자가 피드를 수정한 경우
    func updateFeedItem(feedID: UUID, updatedFeed: Feed, newImages: [UIImage]) {
        
        // 기존 데이터 불러오기
        let request: NSFetchRequest<FeedModel> = FeedModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", feedID as CVarArg)
        request.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(request)
            
            if let feedToUpdate = fetchResults.first {
                
                // 불러온 데이터에 새로 작성한 데이터 넣기
                
                feedToUpdate.title = updatedFeed.title
                feedToUpdate.content = updatedFeed.contents
                feedToUpdate.date = feedToUpdate.date
                
                // 기존 이미지 경로 삭제 및 새 이미지 저장
                let oldImagePaths = feedToUpdate.imagePath?.components(separatedBy: ",") ?? []
                FeedStorageManager().deleteImages(from: oldImagePaths)
                
                let newImagePaths = FeedStorageManager().saveImages(images: newImages, feedID: feedID.uuidString)
                feedToUpdate.imagePath = newImagePaths.joined(separator: ",")
                
                // 변경된 데이터 저장
                try context.save()
                print("Feed item updated successfully")
            } else {
                print("Feed item not found")
            }
        } catch {
            print("Failed to update feed item: \(error)")
        }
    }
}
