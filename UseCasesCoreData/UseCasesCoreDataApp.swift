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
    
    let persistenceController = PersistenceController.shared
     @StateObject var router: Router = Router()
    
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
                }
            }
            .onOpenURL
            { url in
                router.reset()
                handleUrl(url)
            }
        }
    }

    private func handleUrl(_ url: URL)
    {
        // This function takes a url comprised of UUID Strings
        // it parses the url.host first, which will be a project (subject to change)
        // it then parses any element left.
        // The order of these elements is as follows: CategoryID/UseCaseID/StepID.
        // in parsing each element, the function attempts to retrieve
        // a CoreData object Model using the given uuidString and will either
        // return if no object is able to be retrieved, or appends the Route.option(object)
        // where option is one of the members of the Route Enum and object is the retrieved object

        let moc = persistenceController.container.viewContext
        if let project = ModelGetter<ProjectEntity>(moc: moc)
            .getModelById(url.host!)
        {
            router.path.append(Route.project(project))
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
                case 1:
                    guard let category = ModelGetter<CategoryEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    router.path.append(Route.category(category))
                case 2:
                    guard let useCase = ModelGetter<UseCaseEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    router.path.append(Route.useCase(useCase))
                case 3:
                    guard let step = ModelGetter<StepEntity>(moc: moc)
                        .getModelById(currentItem)
                    else { return }
                    router.path.append(Route.step(step))
                default:
                    return
                }
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
            let model = try moc.fetch(fetchRequest).first(where: { String($0.id) == modelId })
            return model as? Model
        }
        catch
        {
            print(error.localizedDescription)
        }
        return nil
    }
}
