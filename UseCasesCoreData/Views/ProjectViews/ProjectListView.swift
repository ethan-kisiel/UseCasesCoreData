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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    @State private var alertIsPresented: Bool = false
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
                            .swipeActions(edge: .leading)
                            {
                                NavigationLink(value: Route.editProject(project))
                                {
                                    Text("Edit")
                                }
                            }.tint(.indigo)
                    }.onDelete(perform: { indexSet in
                        self.indexSet = indexSet
                        alertIsPresented = true
                    })
                    .alert(isPresented: $alertIsPresented)
                    {
                        Alert(
                            title: Text("Do you wish to delete this project?"),
                            message: Text("Doing so will delete this project and all of its children."),
                            primaryButton: .destructive(Text("DELETE"), action: {
                                deleteProject(indexSet: indexSet)
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                        .listRowBackground(NM_MAIN)
                }.listStyle(.plain)
                    .padding()
                    .scrollContentBackground(.hidden)
            }
        }
    }
    
    private func deleteProject(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map{ projects[$0] }.forEach(moc.delete)
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
        ProjectListView()
    }
}
