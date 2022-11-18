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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.title, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    // this fetch request is used for the display of the
    // current project selector
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], animation: .default)
    private var projects: FetchedResults<Project>
    
    @State var project: Project
    // add inline picker for the category selection
    @State var categoryTitle: String = EMPTY_STRING
 
    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    var invalidFields: Bool
    {
        categoryTitle.isEmpty
    }
    
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
                .navigationTitle("Categories")
                .navigationBarTitleDisplayMode(.inline)
            ReturnToTopButton()
        }.background(NM_MAIN)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectDetailsView(project: Project())
    }
}
