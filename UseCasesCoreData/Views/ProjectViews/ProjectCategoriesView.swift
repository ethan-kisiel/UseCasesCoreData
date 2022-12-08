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
    
    @State var isDeletePresented: Bool = false
    
    var sortedProjects: [ProjectEntity]
    {
        projects.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    
    var body: some View
    {
        VStack
        {
            DiscretePicker(displayText: "Project: ", selection: $project, selectables: sortedProjects, keyPath: \ProjectEntity.wrappedTitle)
            
            Spacer()
            
            if project.wrappedCategories.isEmpty
            {
                Text("No categories to show.")
            }
            else
            {
                List
                {
                    ForEach(project.wrappedCategories, id: \.id)
                    { category in
                        CategoryCellView(category: category)
                            .swipeActions(edge: .trailing)
                            {
                                Button(ALERT_DEL)
                                {
                                    isDeletePresented = true
                                    print("DELETED")
                                }
                            }.tint(.red)
                            .alert(isPresented: $isDeletePresented)
                            {
                                Alert(
                                    title: Text("Do you wish to delete this category?"),
                                    message: Text("Doing so will delete this category and all of its children."),
                                    primaryButton: .destructive(Text(ALERT_DEL), action:
                                    {
                                        deleteCategory(category)
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                            .swipeActions(edge: .trailing)
                            {
                                NavigationLink(value: Route.editCategory(category))
                                {
                                    Text("Edit")
                                }
                            }.tint(.indigo)
                    }
                    .onDelete
                    { indexSet in
                    }

                    .listRowBackground(NM_MAIN)
                }.listStyle(.plain)
                .padding()
                .scrollContentBackground(.hidden)
            }
            NavigationButton(text: "Return to Projects")
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
    
    private func deleteCategory(_ category: CategoryEntity)
    {
        withAnimation
        {
            moc.delete(category)
        }
        
        do
        {
            try moc.save()
        }
        catch
        {
            print(error.localizedDescription)
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
