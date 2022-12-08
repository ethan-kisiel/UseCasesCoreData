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
    case name = "Name"
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
    
    @State var sortKey: SortType = .name
    
    var sortedProjects: [ProjectEntity]
    {
        // This is for sorting listed Projects
        []
    }
    
    var body: some View
    {
      
        VStack
        {
            DiscretePicker(displayText: "Sort By: ", selection: $sortKey, selectables: SortType.allCases, keyPath: \SortType.rawValue)
            if projects.isEmpty
            {
                Text("No projects to display.")
            }
            else
            {
                List
                {
                    // sort by category
                    ForEach(projects, id: \.id)
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
        }
        .navigationTitle("Projects")
        .navigationBarTitleDisplayMode(.inline)
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
