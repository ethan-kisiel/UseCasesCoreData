//
//  Router.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/16/22.
//

import Foundation
import SwiftUI

enum ObjectIndex: Int
{
    case Project = 0
    case Category = 1
    case UseCase = 2
    case Step = 3
}


class Router: ObservableObject
{
    // this class houses the navigation path
    // and all functions which modify said path
    // as per apple documentation; being that
    // all path items are (homogenus) of type Route
    // the path is stored as an array rather than
    // a NavigationPath object, which allows for a
    // wider range of modification functions.
    static var shared = Router()
    
    @Published var path: [Route] = []
    
    // target path is a dictionary, whose values are the
    // id's of the object each key represents. Initialize to -1
    // to make sure it initializes as "empty"
    
    @Published var targetPath: [String: BaseModelEntity?] =
    ["project" : nil, "category" : nil,
     "useCase" : nil, "step" : nil]
    
    private func resetTargetPath()
    {
        targetPath["project"] = nil
        targetPath["category"] = nil
        targetPath["useCase"] = nil
        targetPath["step"] = nil
    }
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
    
    public func updateTargetPath(_ object: BaseModelEntity)
    {
        resetTargetPath()
        populateUp(object)
        populateDown(object)
    }
    
    // Takes an enum that represents the index
    // which the for loop will end on.
    // the enum is purely to make the input value
    // easier to read/understand
    public func routeByTargetPath(_ toObject: ObjectIndex)
    {
        // First this function will reset the current path.
        // This function will loop through to the index of
        // the value of the given enum case.
        // it will set each element at the current index to
        // the corresponding object within the targetPath
        
        reset()
        
        for i in 0...toObject.rawValue
        {
            switch i
            {

            // if the user wants to navigate to the
            // Category tab, display the current
            // project's categories
            case ObjectIndex.Category.rawValue:
                if let project = targetPath["project"]
                    as? ProjectEntity
                {
                    path.append(Route.project(project))
                    Log.info("Added Project: \(project) to path.")
                }
                
            // if the user wants to navigate to the
            // Use Case tab, display the current category's
            // use cases
            case ObjectIndex.UseCase.rawValue:
                if let category = targetPath["category"]
                    as? CategoryEntity
                {
                    path.append(Route.category(category))
                    Log.info("Added Category: \(category) to path.")
                }
                
            // if the user wants to navigate to the
            // Step tab, display the current
            // use case's steps
            case ObjectIndex.Step.rawValue:
                if let useCase = targetPath["useCase"]
                    as? UseCaseEntity
                {
                    path.append(Route.useCase(useCase))
                    Log.info("Added UseCase: \(useCase) to path.")
                }
                
            // if something goes wrong in the switch, or
            // the user wants to navigate to the Project tab,
            // return, since the path has already been reset
            // at the beginning of this function
            default:
                Log.warning("Reached end of switch statement")
            }
        }
    }
    
    // This function takes an enum value for each item and
    // returns a boolean which represents whether or not the
    // object specified is valid in the targetPath
    public func isTargetObjectValid
    (_ objectIndex: ObjectIndex) -> Bool
    {
        switch objectIndex
        {
        case .Project:
            return targetPath["project"] != nil && targetPath["project"]??.managedObjectContext != nil
            
        case .Category:
            return targetPath["category"] != nil && targetPath["category"]??.managedObjectContext != nil
            
        case .UseCase:
            return targetPath["useCase"] != nil && targetPath["useCase"]??.managedObjectContext != nil
            
        case .Step:
            return targetPath["step"] != nil && targetPath["step"]??.managedObjectContext != nil
        }
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
    
    public func routeByUrl(_ url: URL)
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
        Log.info(url.absoluteString)
        
        if let project = ModelGetter<ProjectEntity>(moc: moc)
            .getModelById(url.host(percentEncoded: true)!)
        {
            path.append(Route.project(project))
        }
        else
        {
            Log.warning("Failed to route url Project: \(url.host!)")
            return
        }
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
                    
                // CASE: Route to Category
                case 1:
                    guard let category = ModelGetter<CategoryEntity>(moc: moc)
                        .getModelById(currentItem)
                    else
                    {
                        Log.warning("Failed to route url Category")
                        return
                    }
                    Log.info("Successfully routed to category")
                    path.append(Route.category(category))

                // CASE: Route to UseCase
                case 2:
                    guard let useCase = ModelGetter<UseCaseEntity>(moc: moc)
                        .getModelById(currentItem)
                    else
                    {
                        Log.warning("Failed to route url Use Case")
                        return
                    }
                    path.append(Route.useCase(useCase))
                    
                // CASE: Route to Step
                case 3:
                    guard let step = ModelGetter<StepEntity>(moc: moc)
                        .getModelById(currentItem)
                    else
                    {
                        Log.warning("Failed to route url Step")
                        return
                    }
                    path.append(Route.step(step))

                default:
                    return
                }
            }
        }
    }
    
    // recursive functions for setting the
    // targetPath

    private func populateDown<Model: BaseModelEntity>
    (_ object: Model)
    {
        switch type(of: object)
        {
        case is ProjectEntity.Type:
            
            let project = object as? ProjectEntity

            targetPath["project"] = project
            
            if let category = project?.wrappedCategories.first
            {
                populateDown(category)
            }

        case is CategoryEntity.Type:
            let category = object as? CategoryEntity

            targetPath["category"] = category
        
            if let useCase = category?.wrappedUseCases.first
            {
                populateDown(useCase)
            }

        case is UseCaseEntity.Type:
            let useCase = object as? UseCaseEntity
            
            targetPath["useCase"] = useCase

            if let step = useCase?.wrappedSteps.first
            {
                populateDown(step)
            }
            
        case is StepEntity.Type:
            // exit case for recursion
            let step = object as? StepEntity
            targetPath["step"] = step

        default:
            Log.warning("Reached end of Switch.")
        }
    }

    private func populateUp<Model: BaseModelEntity>
    (_ object: Model)
    {
        switch type(of: object)
        {
        case is ProjectEntity.Type:
            // Base case, end of recursion
            targetPath["project"] = object as? ProjectEntity

        case is CategoryEntity.Type:
            let category = object as? CategoryEntity
            
            targetPath["category"] = category
            
            if let project = category?.project
            {
                populateUp(project)
            }

        case is UseCaseEntity.Type:
            let useCase = object as? UseCaseEntity
            
            targetPath["useCase"] = useCase
            if let category = useCase?.category
            {
                populateUp(category)
            }

        case is StepEntity.Type:
            let step = object as? StepEntity
            
            targetPath["step"] = step
            
            if let useCase = step?.useCase
            {
                populateUp(useCase)
            }

        default:
            Log.warning("Reached end of Switch.")
        }
    }
}
