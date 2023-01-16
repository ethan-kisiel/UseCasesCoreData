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
    
    private var targetPath: [Int64] = []
    
    // initialize target path to use the first item in every
    // category
    /*
     targetPath must have functions for the setting of itself
     for Project, Category, UseCase, Step
     
     This will cascade up and down depending on the location of the
     object. Cascading up will always be the parent entity, while
     cascading down will alawys result in the first element of each
     object's children.
    
     Project will always cascade down and Step will always cascade
     down.
    */

    // conversion of target path to url
    private func convertTargetPathToURL() -> URL?
    {
        var components = URLComponents()
        // return empty url i
        if targetPath.count < 1
        {
            return nil
        }
        // since targetPath.count is > 0, there is a project
        components.host = String(targetPath[0])
        
        if targetPath.count > 1
        {
            for i in 1..<targetPath.count
            {
                components.path.append("/\(targetPath[i])")
            }
        }
        
        return components.url
    }
    
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
    
    public func handleUrl(_ url: URL)
    {
        // This function takes a url comprised of UUID Strings
        // it parses the url.host first, which will be a project (subject to change)
        // it then parses any element left.
        // The order of these elements is as follows: CategoryID/UseCaseID/StepID.
        // in parsing each element, the function attempts to retrieve
        // a CoreData object Model using the given uuidString and will either
        // return if no object is able to be retrieved, or appends the Route.option(object)
        // where option is one of the members of the Route Enum and object is the retrieved object

        let moc = PersistenceController.shared.container.viewContext
        
        if let project = ModelGetter<ProjectEntity>(moc: moc)
            .getModelById(url.host!)
        {
            path.append(Route.project(project))
        }
        else { return }
        let pathCount = url.pathComponents.count
        if pathCount != 0
        {
            for index in 1 ..< pathCount
            {
                let currentItem = url.pathComponents[index]
                switch index
                {
                // if the id at the current index corresponds
                // to a valid object, add it to path
                // else, return.
                case 1:
                    guard let category = ModelGetter<CategoryEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    path.append(Route.category(category))
                case 2:
                    guard let useCase = ModelGetter<UseCaseEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    path.append(Route.useCase(useCase))
                case 3:
                    guard let step = ModelGetter<StepEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    path.append(Route.step(step))
                default:
                    return
                }
            }
        }
    }
}
