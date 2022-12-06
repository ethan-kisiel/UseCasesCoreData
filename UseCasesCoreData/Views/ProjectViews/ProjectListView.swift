//
//  ProjectListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/7/22.
//

import SwiftUI

struct ProjectListView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var router: Router
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
    @State private var isDeletePresented: Bool = false
    
    @State private var indexSet: IndexSet = IndexSet()
    
    var body: some View
    {
        VStack
        {
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
                                }
                            }.tint(.red)
                            .alert(isPresented: $isDeletePresented)
                            {
                                Alert(
                                    title: Text("Do you wish to delete this project?"),
                                    message: Text("Doing so will delete this project and all of its children."),
                                    primaryButton: .destructive(Text(ALERT_DEL), action: {
                                        deleteProject(project)
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

struct ProjectListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationStack
        {
            ProjectListView()
        }
    }
}
