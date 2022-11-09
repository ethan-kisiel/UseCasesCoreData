//
//  UseCasesCoreDataApp.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import SwiftUI

// Route must conform to hashable in order to work with
// .destination(for: <Hashable>)
enum Route: Hashable
{
    case projects
    case project(Project)
    case category(Category)
    case useCase(UseCase)
    case step(Step)
}

@main
struct UseCasesCoreDataApp: App
{
    let persistenceController = PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            NavigationStack
            {
                ZStack
                {
                    NM_MAIN.edgesIgnoringSafeArea(.all)
                    // Navigation stack needs an initial view to play off of
                    // It might be better to use the content view for this(?)
                    ProjectsView()
                        .navigationDestination(for: Route.self)
                    { route in
                        switch route
                        {
                        case .projects:
                            ProjectsView()
                            
                        case let .project(project):
                            ProjectDetailsView(project: project)
                            
                        case let .category(category):
                            CategoryDetailsView(category: category)
                            
                        case let .useCase(useCase):
                            UseCaseDetailsView(useCase: useCase)
                            
                        case let .step(step):
                            StepDetailsView(step: step)
                        }
                    }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
