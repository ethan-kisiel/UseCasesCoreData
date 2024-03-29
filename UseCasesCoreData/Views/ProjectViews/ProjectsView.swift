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
    
    private var filteredProjects: [ProjectEntity]
    {
        // This is for sorting listed Projects
        let sortedProjects = projects.sorted
        {
            switch sortKey
            {
            case .title:
                return $0.wrappedTitle < $1.wrappedTitle
            case .lastUpdated:
                return $0.wrappedDate > $1.wrappedDate
            }
        }
        
        // Checks whether there is only one item in the list
        // in which case, that item should now be a part of the
        // target path.
        // MARK: This should probably be moved in future.
        if sortedProjects.count == 1
        {
            if !Router.shared.isTargetObjectValid(.Project)
            {
                Router.shared.updateTargetPath(sortedProjects[0])
            }
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
    
            if filteredProjects.isEmpty
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
                    ForEach(filteredProjects, id: \.id)
                    {
                        project in
                        ProjectCellView(project: project)
                        .swipeActions(edge: .trailing)
                        {
                            Button("Delete", role: .destructive)
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
                            .swipeActions(edge: .trailing)
                        {
                            NavigationLink(value: Route.projectDetails(project))
                            {
                                Text("Details")
                            }
                        }
                        .tint(.gray)
                        
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
            // Navigation tabs
            ToolbarItemGroup(placement: .bottomBar)
            {
                NavigationBottomBar()
            }
            // Search bar
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
