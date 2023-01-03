//
//  EntityIdUtil.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/25/22.
//

import Foundation
import CoreData

class EntityIdUtil
{
    // this is a singleton class, which is responsible
    // for the handling of object id distribution.
    // if the database is fresh; there are no objects of the
    // the specified type, a fresh 64 bit integer is
    // returned to be used as an object id
    // if there are already entries for the specified type
    // the current largest id is incremented and returned.
    // usage: EntityIdUitl.shared.getNewObjectId(<EntityName>.self)
    // note: the entity type must inherit from the BaseModelEntity
    
    static let shared = EntityIdUtil()
    
    func getNewObjectId<T: BaseModelEntity>(_ T: T.Type) -> Int64
    {
        let context = PersistenceController.shared.container.viewContext
        
        let fetchRequest = T.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \BaseModelEntity.id, ascending: false)]
        
        do
        {
            let entities = try context.fetch(fetchRequest)
                .filter { type(of: $0) == T }
            if entities.count > 0
            {
                print(entities[0].id)
                return entities[0].id + 1
            }
        }
        catch
        {
            print("failed to fetch \(T) ")
        }
        
        switch T
        {
        case is ProjectEntity.Type:
            return 0
        case is CategoryEntity.Type:
            return Int64(CAT_ID_DEFAULT)
        case is UseCaseEntity.Type:
            return Int64(UC_ID_DEFAULT)
        case is StepEntity.Type:
            return Int64(STEP_ID_DEFAULT)
        default:
            return -1
        }
    }
}
