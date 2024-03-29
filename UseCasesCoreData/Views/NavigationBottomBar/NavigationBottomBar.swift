//
//  NavigationBottomBar.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/25/23.
//

import SwiftUI

struct NavigationBottomBar: View
{
    @EnvironmentObject var router: Router
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                
                let isProjectValid = Router.shared
                    .isTargetObjectValid(.Project)
                // Project icon
                Image(systemName: "p.square")
                    .onTapGesture
                    {
                        
                        router.routeByTargetPath(.Project)
                    }
                    .padding([.leading, .trailing], 8)
                    .foregroundColor(NM_SEC)
                
                
                let isCategoryValid = Router.shared
                    .isTargetObjectValid(.Category)
                // Category icon
                Image(systemName: "c.square")
                    .onTapGesture
                    {
                        if isProjectValid
                        {
                            router.routeByTargetPath(.Category)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .foregroundColor(NM_SEC)
                    .opacity(isProjectValid ? 1 : 0.5)
                
                
                let isUseCaseValid = Router.shared
                    .isTargetObjectValid(.UseCase)
                // Use Case icon
                Image(systemName: "u.square")
                    .onTapGesture
                    {
                        if isCategoryValid
                        {
                            router.routeByTargetPath(.UseCase)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .foregroundColor(NM_SEC)
                    .opacity(isCategoryValid ? 1 : 0.5)
                
                
                
                let isStepValid = Router.shared
                    .isTargetObjectValid(.Step)
                // Step icon
                Image(systemName: "s.square")
                    .onTapGesture
                    {
                        if isUseCaseValid
                        {
                            router.routeByTargetPath(.Step)
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .foregroundColor(NM_SEC)
                    .opacity(isUseCaseValid ? 1 : 0.5)
            }
        }
    }
}

struct NavigationBottomBar_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationBottomBar()
    }
}
