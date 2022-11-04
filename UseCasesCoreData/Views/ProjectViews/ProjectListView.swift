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
    // get only projects created by this user
    var body: some View
    {
        // if there are projects saved to the localDB with a createdBy
        // value equal to the current userId, those projects will be
        // looped through and presented as a ProjectCellView in the loop.
        // sliding to delete will cause the element at the current index to
        // be deleted using the ProjectManager.
        
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
                        .environment(\.managedObjectContext, moc)
                }.onDelete(perform: deleteProject)
            }.listStyle(.plain)
            .padding()
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
