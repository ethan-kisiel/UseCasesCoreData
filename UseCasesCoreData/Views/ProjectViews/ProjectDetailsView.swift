//
//  ProjectDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/8/22.
//

import Neumorphic
import SwiftUI

struct ProjectDetailsView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.title, ascending: true)], animation: .default)
    private var categories: FetchedResults<CategoryEntity>
    
    // this fetch request is used for the display of the
    // current project selector
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ProjectEntity.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<ProjectEntity>
    
    @State var project: ProjectEntity
 
    @State var showAddFields: Bool = false
    @State var refresh: Bool = false
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Menu
                {
                    Picker(selection: $project,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(projects, id: \.self)
                            { project in
                                Text(project.wrappedTitle)
                            }
                    })
                } label:
                {
                    Text("Project: **\(project.wrappedTitle)**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }
                Spacer()
                Image(systemName: showAddFields ? LESS_ICON : MORE_ICON)
                    .onTapGesture
                {
                    showAddFields.toggle()
                }
            }.padding()
            
            if showAddFields
            {
                AddCategoryView(project: project)
            }
            
            Spacer()
            
            CategoryListView(project: project)
            
            Spacer()
        
            ReturnToTopButton()
            
        }
        .background(NM_MAIN)
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectDetailsView(project: ProjectEntity())
    }
}
