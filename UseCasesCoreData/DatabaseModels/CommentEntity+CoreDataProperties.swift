//
//  CommentEntity+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/10/23.
//
//

import Foundation
import CoreData


extension CommentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentEntity> {
        return NSFetchRequest<CommentEntity>(entityName: "CommentEntity")
    }

    @NSManaged public var commentText: String?
    @NSManaged public var createdBy: String?
    @NSManaged public var owningEntity: BaseModelEntity?

    
    var wrappedCreatedBy: String
    {
        createdBy ?? "No User"
    }
}

extension CommentEntity : Identifiable {

}
