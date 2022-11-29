//
//  Persistence.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "UseCasesCoreData")
        
        container.loadPersistentStores
        { storeDescription, error in
            if let error = error as NSError?
            {
                print("ERROR LOADING PERSISTENT STORES")
                print(error)
            }
        }
        container.viewContext
            .automaticallyMergesChangesFromParent = true

        container.viewContext
            .mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
