//
//  BaseModelEntity+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/23/22.
//
//

import Foundation
import CoreData


extension BaseModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModelEntity> {
        return NSFetchRequest<BaseModelEntity>(entityName: "BaseModelEntity")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: Int64
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdBy: String?
    
    @NSManaged public var comments: NSSet?
    
    var stringId: String
    {
        return String(id)
    }
    
    var wrappedTitle: String
    {
        title ?? MISSING_DATA
    }
    
    var wrappedDescription: String
    {
        desc ?? MISSING_DATA
    }
    
    var wrappedDate: String
    {
        lastUpdated?.formatted(date: .numeric, time: .omitted) ?? MISSING_DATA
    }
    
    var wrappedComments: [CommentEntity]
    {
        let set = comments as? Set<CommentEntity> ?? []
        
        return set.sorted {$0.wrappedText > $1.wrappedText}
    }
}

// MARK: Generated accessors for comments
extension BaseModelEntity {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: CommentEntity)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: CommentEntity)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension BaseModelEntity : Identifiable {

}
