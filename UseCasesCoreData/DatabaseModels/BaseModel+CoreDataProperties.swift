//
//  BaseModel+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//
//

import Foundation
import CoreData


extension BaseModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModel> {
        return NSFetchRequest<BaseModel>(entityName: "BaseModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var created: Date?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var name: String?

}

extension BaseModel : Identifiable {

}
