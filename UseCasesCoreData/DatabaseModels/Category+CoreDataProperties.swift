//
//  Category+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension Category
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category>
    {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var parent: Project?
    @NSManaged public var useCases: NSSet?
}

// MARK: Generated accessors for useCases

extension Category
{
    @objc(addUseCasesObject:)
    @NSManaged public func addToUseCases(_ value: UseCase)

    @objc(removeUseCasesObject:)
    @NSManaged public func removeFromUseCases(_ value: UseCase)

    @objc(addUseCases:)
    @NSManaged public func addToUseCases(_ values: NSSet)

    @objc(removeUseCases:)
    @NSManaged public func removeFromUseCases(_ values: NSSet)
}
