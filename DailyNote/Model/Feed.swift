//
//  Feed.swift
//  DailyNote
//
//  Created by 권정근 on 11/25/24.
//

import Foundation
import UIKit

struct Feed: Codable {
    let title: String?
    let contents: String?
    let date: Date?
    let imagePath: [String]
}

struct FeedManager: Codable {
    let id: UUID
    let feed: Feed
    
    /// 새로운 피드를 생성할 때 사용하는 생성자
    init(feed: Feed) {
        self.id = UUID() // 새로운 UUID 생성
        self.feed = feed
    }
    
    /// Core Data에서 불러온 피드를 초기화할 때 사용하는 생성자
    init(id: UUID, feed: Feed) {
        self.id = id // 기존 ID 유지
        self.feed = feed
    }
}

