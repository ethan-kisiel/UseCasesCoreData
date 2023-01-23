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
    
    @Published var path: [Route] = []
    
    // target path is a dictionary, whose values are the
    // id's of the object each key represents. Initialize to -1
    // to make sure it initializes as "empty"
    
    private var targetPath: [String: Int64] =
    ["project" : -1, "category" : -1,
     "useCase" : -1, "step" : -1]
    
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
        populateUp(object)
        populateDown(object)
    }
    
    // Takes an enum that represents the index
    // which the for loop will end on.
    // the enum is purely to make the input value
    // easier to read/understand
    public func routeByTargetPath(_ toObject: ObjectIndex)
    {
        var components = URLComponents()
        // return the URL for the current targetPath
        components.host = String(describing: targetPath["project"])
        
        for index in 1...toObject.rawValue
        {
            switch index
            {
            case ObjectIndex.Category.rawValue:
                components.path.append("/\(String(describing: targetPath["category"]))")
                Log.info("AddedCategoryToPath")

            case ObjectIndex.UseCase.rawValue:
                components.path.append("/\(String(describing: targetPath["useCase"]))")
                Log.info("AddedUseCaseToPath")

            case ObjectIndex.Step.rawValue:
                components.path.append("/\(String(describing: targetPath["step"]))")
                Log.info("AddedStepToPath")
            
            default:
                Log.warning("Reached end of switch.")
            }
        }
        
        if let url = components.url
        {
            self.routeByUrl(url)
        }
        else
        {
            Log.warning("Failed to produce valid url.")
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
        
        if let project = ModelGetter<ProjectEntity>(moc: moc)
            .getModelById(url.host!)
        {
            path.append(Route.project(project))
        }
        else
        {
            Log.warning("Failed to route url Project")
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
            targetPath["project"] = object.id
            let project = object as? ProjectEntity
            if let category = project?.wrappedCategories[0]
            {
                populateDown(category)
            }

        case is CategoryEntity.Type:
            targetPath["category"] = object.id
            let category = object as? CategoryEntity
            if let useCase = category?.wrappedUseCases[0]
            {
                populateDown(useCase)
            }

        case is UseCaseEntity.Type:
            targetPath["useCase"] = object.id
            let useCase = object as? UseCaseEntity
            if let step = useCase?.wrappedSteps[0]
            {
                populateDown(step)
            }
        case is StepEntity.Type:
            // exit case for recursion
            targetPath["step"] = object.id

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
            targetPath["project"] = object.id

        case is CategoryEntity.Type:
            targetPath["category"] = object.id
            let category = object as? CategoryEntity
            if let project = category?.project
            {
                populateUp(project)
            }

        case is UseCaseEntity.Type:
            targetPath["useCase"] = object.id
            let useCase = object as? UseCaseEntity
            if let category = useCase?.category
            {
                populateUp(category)
            }

        case is StepEntity.Type:
            targetPath["step"] = object.id
            let step = object as? StepEntity
            if let useCase = step?.useCase
            {
                populateUp(useCase)
            }
            

        default:
            Log.warning("Reached end of Switch.")
        }
    }
}
