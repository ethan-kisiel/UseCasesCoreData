//
//  BaseModel+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension BaseModel
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModel>
    {
        return NSFetchRequest<BaseModel>(entityName: "BaseModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var customId: String?
}

extension BaseModel: Identifiable
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
