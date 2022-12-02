//
//  UserIdUtil.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/2/22.
//

import Foundation
import CloudKit


struct UserIdUtil
{
    static let shared = UserIdUtil()

    private func handleGetUserId(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ())
    {
        let container = CKContainer.default()
        container.fetchUserRecordID
        { recordId, error in
            if error != nil
            {
                // MARK: log error here
                complete(nil, error as NSError?)
            }
            else
            {
                complete(recordId, nil)
            }
        }
    }
    
    
    func getUserId() -> String?
    {
        var userId: String?
        
        handleGetUserId
        { (recordId: CKRecord.ID?, error) in
            if let recordUserId = recordId?.recordName
            {
                userId = recordUserId
            }
            else
            {
                // MARK: log no user found
                userId = nil
            }
        }
        
        return userId
    }
}
