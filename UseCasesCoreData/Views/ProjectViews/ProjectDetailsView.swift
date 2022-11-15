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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)], animation: .default)
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
                            Text(project.wrappedName)
                        }
                    })
                } label:
                {
                    Text("Project: **\(project.wrappedName)**")
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
                VStack(spacing: 5)
                {
                    withAnimation
                    {
                        TextBoxWithFocus("Category", text: $categoryTitle, isFocused: $isFocused)
                            .padding(8)
                    }
                    
                    Button(action:
                            {
                        // if there is a category with the specified title
                        // the use case is added to that category
                        // otherwise, a category is created
                        // and the use case is added
                        addCategory(name: categoryTitle)
                        
                        categoryTitle = EMPTY_STRING
                        isFocused = false
                    })
                    {
                        Text("Add Category").foregroundColor(invalidFields ? .secondary: NM_SEC)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .disabled(categoryTitle.isEmpty)
                    .padding(8)
                }.padding()
            }
            Spacer()
            CategoryListView(project: project)
            Spacer()
                .navigationTitle("Categories")
                .navigationBarTitleDisplayMode(.inline)
        }.background(NM_MAIN)
    }

    
    func addCategory(name: String)
    {
        let category = Category(context: moc)
        category.id = UUID()
        category.created = Date()
        category.lastUpdated = Date()
        category.name = name
        category.parent = project
        
        do
        {
            try moc.save()
        }
        catch
        {
            print("UNABLE TO SAVE")
            print(error.localizedDescription)
        }
    }
}

struct ProjectDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        ProjectDetailsView(project: Project())
    }
}
