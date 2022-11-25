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
        switch T
        {
        case is ProjectEntity.Type:
            return 0
        case is CategoryEntity.Type:
            return 1000000000000000000
        case is UseCaseEntity.Type:
            return 10
        case is StepEntity.Type:
            return 50
        default:
            return -1
        }
    }
}
