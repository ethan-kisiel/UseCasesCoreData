//
//  EntityIdUtil.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/25/22.
//

import Foundation
import CoreData

struct EntityIdUtil
{
    static let shared = EntityIdUtil()
    
    func giveObjectId<T: BaseModelEntity>(_ T: T.Type) -> Int64
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
