//
//  UseCasePriority.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/18/22.
//

import Foundation
enum Priority: String, CaseIterable
{
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct UseCasePriority
{
    let priority: Priority
    
    var sortKey: String
    {
        switch self.priority
        {
        case .low:
            return "0"
        case .medium:
            return "1"
        case .high:
            return "2"
        }
    }
}
