//
//  Category+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension CategoryEntity
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity>
    {
        return NSFetchRequest<CategoryEntity>(entityName: "Category")
    }

    @NSManaged public var project: ProjectEntity?
    @NSManaged public var useCases: NSSet?
    
    var wrappedUseCases: [UseCaseEntity]
    {
        let set = useCases as? Set<UseCaseEntity> ?? []
        
        return set.sorted
        { $0.wrappedTitle > $1.wrappedTitle }
    }
}

// MARK: Generated accessors for useCases

extension CategoryEntity
{
    @objc(addUseCasesObject:)
    @NSManaged public func addToUseCases(_ value: UseCaseEntity)

    @objc(removeUseCasesObject:)
    @NSManaged public func removeFromUseCases(_ value: UseCaseEntity)

    @objc(addUseCases:)
    @NSManaged public func addToUseCases(_ values: NSSet)

    @objc(removeUseCases:)
    @NSManaged public func removeFromUseCases(_ values: NSSet)
}
