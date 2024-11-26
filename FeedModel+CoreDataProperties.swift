//
//  FeedModel+CoreDataProperties.swift
//  DailyNote
//
//  Created by 권정근 on 11/25/24.
//
//

import Foundation
import CoreData


extension FeedModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedModel> {
        return NSFetchRequest<FeedModel>(entityName: "FeedModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var content: String?
    @NSManaged public var imagePath: String?

}

extension FeedModel : Identifiable {

}
