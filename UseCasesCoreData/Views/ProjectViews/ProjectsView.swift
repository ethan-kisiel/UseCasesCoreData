//
//  ProjectView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/7/22.
//

import CoreData
import Neumorphic
import SwiftUI

enum SortType: String, CaseIterable, Hashable
{
    case title = "Title"
    case lastUpdated = "Last Updated"
}

struct ProjectsView: View
{
    // this view contains a list of all projects, as well as the
    // form to create new projects
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
    @State var isDeletePresented: Bool = false
    
    @State var projectToDelete: ProjectEntity? = nil
    
    @State var searchText: String = EMPTY_STRING
    
    @State var sortKey: SortType = .title
    
    var filteredCategories: [ProjectEntity]
    {
        // This is for sorting listed Projects
        let sortedProjects = projects.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        }
        
        if searchText.isEmpty
        {
            return sortedProjects
        }
        
        switch sortKey
        {
            case .lastUpdated:
                return sortedProjects.filter
                {
                    $0.wrappedDate.lowercased()
                        .contains(searchText.lowercased())
                }
            case .title:
                return sortedProjects.filter
                {
                    $0.wrappedTitle.lowercased()
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
                DiscretePicker(displayText: "Sort By: ", selection: $sortKey, selectables: SortType.allCases, keyPath: \SortType.rawValue)
                
                Spacer()
            }
            .padding(.leading)
            
            Spacer()
    
            if filteredCategories.isEmpty
            {
                Text("No projects to display.")
                    .foregroundColor(.secondary)
                    .opacity(0.5)
    
                Spacer()
            }
            else
            {
                List
                {
                    // sort by category
                    ForEach(filteredCategories, id: \.id)
                    {
                        project in
                        ProjectCellView(project: project)
                            .swipeActions(edge: .trailing)
                        {
                            Button("Delete")
                            {
                                isDeletePresented = true
                                projectToDelete = project
                            }
                        }.tint(.red)
                        .alert(isPresented: $isDeletePresented)
                        {
                            Alert(
                                title: Text("Do you wish to delete this project?"),
                                message: Text("Doing so will delete this project and all of its children."),
                                primaryButton: .destructive(Text(ALERT_DEL), action: {
                                    if projectToDelete != nil
                                    {
                                        deleteProject(projectToDelete!)
                                        deleteProject(projectToDelete!)
                                        
                                    }
                                    projectToDelete = nil
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                        .swipeActions(edge: .trailing)
                        {
                            NavigationLink(value: Route.editProject(project))
                            {
                                Text("Edit")
                            }
                            
                        }.tint(.indigo)
                        
                    }
                    .onDelete
                    { indexSet in
                        // This is here so that the EditButton()
                        // functionality still works.
                    }
                    .listRowBackground(NM_MAIN)
                }.listStyle(.plain)
                    .padding()
                    .scrollContentBackground(.hidden)
            }
            
            Spacer()
            
        }
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .toolbar
        {
            ToolbarItemGroup(placement: .navigationBarTrailing)
            {
                HStack
                {
                    projects.count > 0 ? EditButton() : nil
                    
                    NavigationLink(value: Route.addProject)
                    {
                        Image(systemName: ADD_ICON)
                    }
                }
            }
        }
    }
 
    
    private func deleteProject(_ project: ProjectEntity)
    {
        withAnimation
        {
            moc.delete(project)
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

struct ProjectsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let moc = PersistenceController.shared.container.viewContext
        ProjectsView()
            .environment(\.managedObjectContext, moc)
    }
}
