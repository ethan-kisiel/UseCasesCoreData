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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.lastUpdated, ascending: true)], animation: .default)
    private var projects: FetchedResults<Project>

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
                    }.onDelete(perform: deleteProject)
                        .swipeActions(edge: .leading)
                    {
                        NavigationLink(value: Route.projects)
                        {
                            Text("Edit")
                        }
                    }.tint(.indigo)
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
