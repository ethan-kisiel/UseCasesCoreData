//
//  Step+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension StepEntity
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StepEntity>
    {
        return NSFetchRequest<StepEntity>(entityName: "Step")
    }

    @NSManaged public var body: String?
    @NSManaged public var useCase: UseCaseEntity?
}
