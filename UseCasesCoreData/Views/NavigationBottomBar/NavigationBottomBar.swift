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
                // Project icon
                Image(systemName: "p.circle")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.Project)
                    }
                
                // Category icon
                Image(systemName: "c.circle")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.Category)
                    }
                
                // Use Case icon
                Image(systemName: "u.circle")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.UseCase)
                    }
                
                // Step icon
                Image(systemName: "s.circle")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.Step)
                    }
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
