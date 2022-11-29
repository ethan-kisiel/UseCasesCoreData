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
    
    @NSManaged public var category: CategoryEntity?
    @NSManaged public var steps: NSSet?
    
    
    var wrappedSteps: [StepEntity]
    {
        let set = steps as? Set<StepEntity> ?? []
        
        return set.sorted
        { $0.wrappedTitle > $1.wrappedTitle }
    }
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
}
