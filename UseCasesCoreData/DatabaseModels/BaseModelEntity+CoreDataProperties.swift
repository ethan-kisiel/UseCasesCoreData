//
//  BaseModelEntity+CoreDataProperties.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/23/22.
//
//

import Foundation
import CoreData


extension BaseModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseModelEntity> {
        return NSFetchRequest<BaseModelEntity>(entityName: "BaseModelEntity")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var id: Int64
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdBy: String?
    
    
    var wrappedTitle: String
    {
        title ?? MISSING_DATA
    }
    
    var wrappedDescription: String
    {
        desc ?? MISSING_DATA
    }
    
    var wrappedDate: String
    {
        lastUpdated?.formatted(date: .numeric, time: .omitted) ?? MISSING_DATA
    }

}

extension BaseModelEntity : Identifiable {

}
