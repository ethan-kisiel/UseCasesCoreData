//
//  UseCase+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/4/22.
//
//

import CoreData
import Foundation

extension UseCaseEntity
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UseCaseEntity>
    {
        return NSFetchRequest<UseCaseEntity>(entityName: "UseCase")
    }

    @NSManaged public var priority: String?
    @NSManaged public var prioritySort: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var parent: CategoryEntity?
    @NSManaged public var steps: NSSet?
}

// MARK: Generated accessors for steps

extension UseCaseEntity
{
    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: StepEntity)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: StepEntity)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)

    var wrappedPriority: String
    {
        self.priority ?? Priority.medium.rawValue
    }
}
