//
//  Persistence.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import CloudKit
import CoreData

struct PersistenceController
{
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init()
    {
        container = NSPersistentCloudKitContainer(name: "UseCasesCoreData")

        container.loadPersistentStores
        { _, error in
            if let error = error as NSError?
            {
                Log.error("Error loading persistent stores: \(error)")
            }
        }
        container.viewContext
            .automaticallyMergesChangesFromParent = true

        container.viewContext
            .mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // easy access to the managed object context
    var moc: NSManagedObjectContext
    {
        container.viewContext
    }
}
