//
//  Project+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension ProjectEntity
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity>
    {
        return NSFetchRequest<ProjectEntity>(entityName: "Project")
    }

    @NSManaged public var categories: NSSet?
}

// MARK: Generated accessors for categories

extension ProjectEntity
{
    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: CategoryEntity)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: CategoryEntity)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)
}
