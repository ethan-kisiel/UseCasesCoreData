//
//  BaseModel+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension BaseModelEntity
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModelEntity>
    {
        return NSFetchRequest<BaseModelEntity>(entityName: "BaseModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var customId: String?
}

extension BaseModelEntity: Identifiable
{
    var wrappedId: String
    {
        id?.uuidString ?? MISSING_DATA
    }

    var wrappedTitle: String
    {
        title ?? MISSING_DATA
    }

    var wrappedCustomId: String
    {
        customId ?? MISSING_DATA
    }
}
