//
//  UserIdUtil.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/2/22.
//

import Foundation
import CloudKit


class UserInfoUtil
{
    //
    static let shared = UserInfoUtil()

    private var hasPermission: Bool = false
    private var userIdentity: CKUserIdentity? = nil
    
    init()
    {
        fetchiCloudUserRecord()
    }
    
    let container = CKContainer.default()
    
    public func requestPermission()
    {
        container.requestApplicationPermission([.userDiscoverability])
        { [weak self] requestStatus, requestError in
            DispatchQueue.main.async
            {
                if requestStatus == .granted
                {
                    self?.hasPermission = true
                    Log.info("Successfully granted iCloud permissions.")
                }
                else
                {
                    Log.error("Failed to grant iCloud permissions.")
                }
            }
        }
    }

    private func fetchiCloudUserRecord()
    {
        container.fetchUserRecordID
        { [weak self] requestId, requestError in
            if let id = requestId
            {
                self?.discoveriCloudUser(id)
            }
            else
            {
                Log.warning("Failed to fetch User Record ID")
            }
        }
    }
    
    private func discoveriCloudUser(_ id: CKRecord.ID)
    {
        container.discoverUserIdentity(withUserRecordID: id)
        { [weak self] requestIdentity, requestError in
            DispatchQueue.main.async
            {
                if let identity = requestIdentity
                {
                    self?.userIdentity = identity
                }
                else
                {
                    Log.error("Failed to discover iCloud user.")
                }
            }
        }
    }
    
    public func getUserId() -> String?
    {
        if !hasPermission
        {
            requestPermission()
        }
        

        if let userId = userIdentity?.userRecordID?.recordName
        {
            return userId
        }
        
        Log.error("Failed to retrieve user record ID")
        
        return nil
    }
    
    public func getUserName() -> String?
    {
        if !hasPermission
        {
            requestPermission()
        }

        if let userName = userIdentity?.nameComponents?.givenName
        {
            return userName
        }
        
        Log.warning("Failed to retrieve user given name.")
        
        return nil
    }
    
    public func getUserFullName() -> String?
    {
        if !hasPermission
        {
            requestPermission()
        }
        
        if let userName = userIdentity?.nameComponents?.givenName,
           let lastName = userIdentity?.nameComponents?.familyName
        {
            return userName + " " + lastName
        }
        
        Log.warning("Failed to retrieve user given or family name.")
        
        return nil
    }
}
