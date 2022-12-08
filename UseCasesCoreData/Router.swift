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
    // this class houses the navigation path
    // and all functions which modify said path
    // as per apple documentation; being that
    // all path items are (homogenus) of type Route
    // the path is stored as an array rather than
    // a NavigationPath object, which allows for a
    // wider range of modification functions.
    
    @Published var path: [Route] = []
    
    func lastPage()
    {
        if path.count > 1
        {
            path.removeLast()
        }
    }
    
    func goToCategories()
    {
        withAnimation
        {
            while path.count > 1
            {
                path.removeLast()
            }
        }
    }
    
    func reset()
    {
        withAnimation
        {
            path = []
        }
    }
}
