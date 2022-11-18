//
//  Router.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/16/22.
//

import Foundation
import SwiftUI

class Router: ObservableObject
{
    @Published var path = NavigationPath()
    
    func lastPage()
    {
        if path.count > 1
        {
            path.removeLast()
        }
    }

    func reset()
    {
        path = NavigationPath()
    }
}
