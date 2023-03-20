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
                    Log.info("iCloud permission request granted.")
                }
                else
                {
                    Log.warning("iCloud permission request denied.")
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
                    Log.warning("Failed to discover iCloud user")
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
            print(userId)
            return userId
        }
        print("COULDN'T GET USER ID")
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
        Log.warning("Failed to retrieve user name.")
        return nil
    }
    
    public func getUserFullName() -> String?
    {
        if !hasPermission
        {
            requestPermission()
        }
        else
        {
            if let userName = userIdentity?.nameComponents?.givenName,
               let lastName = userIdentity?.nameComponents?.familyName
            {
                return userName + " " + lastName
            }
            
            return nil
        }
        return nil
    }
   /* public func getUserStatus()
    {
        userIdentity.
    }*/
}
