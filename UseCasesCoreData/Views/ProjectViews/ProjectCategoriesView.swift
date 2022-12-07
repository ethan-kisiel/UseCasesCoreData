//
//  ProjectDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/8/22.
//

import Neumorphic
import SwiftUI

struct ProjectCategoriesView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var router: Router
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.title, ascending: true)], animation: .default)
    private var categories: FetchedResults<CategoryEntity>
    
    // this fetch request is used for the display of the
    // current project selector
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
    @State var project: ProjectEntity
 
    @State var showAddFields: Bool = false
    
    @State var refresh: Bool = false
    
    @State var searchText: String = ""

    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Menu
                {
                    Picker(selection: $project,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(projects, id: \.self)
                            { project in
                                Text(project.wrappedTitle)
                            }
                    })
                } label:
                {
                    Text("Project: **\(project.wrappedTitle)**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }
                
                Spacer()
                
            }.padding()
            
            Spacer()
            
            CategoryListView(project: project)
            
            Spacer()
        
            NavigationButton(text: "Return to Projects List")
            {
                router.reset()
            }
        }
        .background(NM_MAIN)
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .toolbar
        {
            ToolbarItemGroup(placement: .navigationBarTrailing)
            {
                HStack
                {
                    categories.count > 0 ? EditButton() : nil
                    
                    NavigationLink(value: Route.addCategory(project))
                    {
                        Image(systemName: ADD_ICON)
                    }
                }
            }
        }
    }
}

struct ProjectDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectCategoriesView(project: ProjectEntity())
    }
}
