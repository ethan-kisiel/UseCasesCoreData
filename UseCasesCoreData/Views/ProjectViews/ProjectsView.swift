//
//  ProjectView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/7/22.
//

import CoreData
import Neumorphic
import SwiftUI

struct ProjectsView: View
{
    // this view contains a list of all projects, as well as the
    // form to create new projects
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
   
   

    @State var showAddFields: Bool = false
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Spacer()
                Image(systemName: showAddFields ? LESS_ICON : MORE_ICON)
                    .onTapGesture
                {
                    showAddFields.toggle()
                }
            }.padding()
            
            if showAddFields
            {
               AddProjectView()
            }
            
            Spacer()
            ProjectListView()
            Spacer()
                .navigationTitle("Projects")
                .navigationBarTitleDisplayMode(.inline)
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
