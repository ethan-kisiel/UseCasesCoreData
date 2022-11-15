//
//  UseCase+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/4/22.
//
//

import Foundation
import CoreData


extension UseCase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UseCase> {
        return NSFetchRequest<UseCase>(entityName: "UseCase")
    }

    @NSManaged public var priority: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var parent: Category?
    @NSManaged public var steps: NSSet?

}

// MARK: Generated accessors for steps
extension UseCase {

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: Step)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: Step)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSSet)
    
    var wrappedPriority: String
    {
        self.priority ?? Priority.medium.rawValue
    }
}
