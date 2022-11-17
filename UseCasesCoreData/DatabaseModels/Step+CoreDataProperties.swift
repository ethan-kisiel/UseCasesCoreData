//
//  Step+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import CoreData
import Foundation

extension Step
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Step>
    {
        return NSFetchRequest<Step>(entityName: "Step")
    }

    @NSManaged public var body: String?
    @NSManaged public var parent: UseCase?
}
