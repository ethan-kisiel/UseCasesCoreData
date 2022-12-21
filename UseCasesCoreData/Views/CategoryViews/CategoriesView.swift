//
//  ProjectDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/8/22.
//

import Neumorphic
import SwiftUI

struct CategoriesView: View
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
    
    @State var sortKey: SortType = .title
    
    @State var isDeletePresented: Bool = false
    
    private var sortedProjects: [ProjectEntity]
    {
        projects.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    
    private var filteredCategories: [CategoryEntity]
    {
        let sortedCategories = project.wrappedCategories.sorted
        {
            switch sortKey
            {
            case .title:
                return $0.wrappedTitle < $1.wrappedTitle
            case .lastUpdated:
                return $0.wrappedDate > $1.wrappedDate
            }
        }
        
        if searchText.isEmpty
        {
            return sortedCategories
        }
        
        switch sortKey
        {
            case .title:
                return sortedCategories.filter
                {
                    $0.wrappedTitle.lowercased()
                        .contains(searchText.lowercased())
                }
            case .lastUpdated:
                return sortedCategories.filter
                {
                    $0.wrappedDate.lowercased()
                        .contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                VStack(alignment: .leading)
                {
                    DiscretePicker(displayText: "Sort by: ", selection: $sortKey, selectables: SortType.allCases, keyPath: \SortType.rawValue)
                    
                    DiscretePicker(displayText: "Project: ", selection: $project, selectables: sortedProjects, keyPath: \ProjectEntity.wrappedTitle)
                }
                
                Spacer()
            }
            .padding(.leading)
            
            Spacer()
            
            if filteredCategories.isEmpty
            {
                Text("No categories to show.")
                    .foregroundColor(.secondary)
                    .opacity(0.5)
                
                Spacer()
            }
            else
            {
                List
                {
                    ForEach(filteredCategories, id: \.id)
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
            
            ToolbarItemGroup(placement: .bottomBar)
            {
                NeumorphicButton("Return to Projects")
                {
                    router.reset()
                }
                .padding(.bottom)
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
        CategoriesView(project: ProjectEntity())
    }
}
