//
//  UseCasesCoreDataApp.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/2/22.
//

import CoreData
import SwiftUI
// Route must conform to hashable in order to work with
// .destination(for: <Hashable>)
enum Route: Hashable
{
    case projects
    
    case addProject
    case addCategory(ProjectEntity)
    case addUseCase(CategoryEntity)
    case addStep(UseCaseEntity)

    case project(ProjectEntity)
    case category(CategoryEntity)
    case useCase(UseCaseEntity)
    case step(StepEntity)

    case editProject(ProjectEntity)
    case editCategory(CategoryEntity)
    case editUseCase(UseCaseEntity)
    case editStep(StepEntity)
    
    case projectDetails(ProjectEntity)
}

@main
struct UseCasesCoreDataApp: App
{
    // hack for getting permission when app loads
    @State private var hasLoaded = false
    
    @StateObject var router: Router = Router.shared
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene
    {
        WindowGroup
        {
            NavigationStack(path: $router.path)
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

                                
                            case .addProject:
                                ProjectFieldsView()
                                
                            case let .addCategory(project):
                                CategoryFieldsView(project: project)
                            
                            case let .addUseCase(category):
                                UseCaseFieldsView(category: category)
                            
                            case let .addStep(useCase):
                                StepFieldsView(useCase: useCase)


                            case let .project(project):
                                CategoriesView(project: project)

                            case let .category(category):
                                UseCasesView(category: category)

                            case let .useCase(useCase):
                                StepsView(useCase: useCase)

                            case let .step(step):
                                StepDetailsView(step: step)


                            case let .editProject(project):
                                ProjectFieldsView(project)

                            case let .editCategory(category):
                                CategoryFieldsView(category)

                            case let .editUseCase(useCase):
                                UseCaseFieldsView(useCase)

                            case let .editStep(step):
                                StepFieldsView(step)
                            
                            case let .projectDetails(project):
                                ProjectDetailsView(project: project)
                            }
                        }
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(router)
            .onAppear
            {
                // This will request iCloud permissions on
                // startup
                if hasLoaded == false
                {
                    hasLoaded = true
                    
                    UserInfoUtil.shared.requestPermission()
                    
                    // This creates a fetch request for projects,
                    // then sends the first instance of the returned
                    // [ProjectEntity] and uses that object to
                    // populate the router's targetPath variable
                    
                    let request: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
                    
                    do
                    {
                        let result =  try persistenceController
                            .container.viewContext
                            .fetch(request)
                        
                        
                        if let firstProject = result.first
                        {
                            router.updateTargetPath(firstProject)
                        }
                        else
                        {
                            Log.warning("Fetch request returned zero projects.")
                        }
                    }
                    catch
                    {
                        Log.error("Failed to fetch projects")
                    }
                }
            }
            .onOpenURL
            { url in
                router.reset()
                router.routeByUrl(url)
            }
        }
    }
}

struct ModelGetter<Model: BaseModelEntity>
{
    // This generic struct is instantiated with an object type which,
    // conforms to BaseModel, and then uses that generic type to fetch
    // the first element where the given modelId == the id.uuidString
    // member of that element. If no element is found with that id.uuidString
    // the function returns nil, else returns found element/model

    let moc: NSManagedObjectContext

    func getModelById(_ modelId: String) -> Model?
    {
        let fetchRequest = Model.fetchRequest()
        
        do
        {
            for m in try moc.fetch(fetchRequest)
            {
                Log.info("id for \(Model.description()): \(m.stringId), \(modelId) : \(modelId == m.stringId)")
            }
            
            let model = try moc.fetch(fetchRequest)
                .first(where: { $0.stringId == modelId })
            
            return model as? Model
        }
        catch
        {
            Log.error("Failed to retrieve model with id: \(modelId)")
        }
        return nil
    }
}
