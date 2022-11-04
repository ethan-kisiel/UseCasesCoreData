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
                // Navigation stack needs an initial view to play off of
                // It might be better to use the content view for this(?)
                ProjectsView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .navigationDestination(for: Route.self)
                    { route in
                        switch route
                        {
                        case .projects:
                            ProjectsView()
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)

                        case let .project(project):
                            ProjectDetailsView(project: project)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)

                        case let .category(category):
                            CategoryDetailsView(category: category)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)

                        case let .useCase(useCase):
                            UseCaseDetailsView(useCase: useCase)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        }
                    }
            }
        }
    }
}
