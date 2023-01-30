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
                Image(systemName: "p.square")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.Project)
                    }
                
                // Category icon
                Image(systemName: "c.square")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.Category)
                    }
                
                // Use Case icon
                Image(systemName: "u.square")
                    .onTapGesture
                    {
                        router.routeByTargetPath(.UseCase)
                    }
                
                // Step icon
                Image(systemName: "s.square")
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
