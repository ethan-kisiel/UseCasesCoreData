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
    @State var project: Project
    // add inline picker for the category selection
    @State var categoryTitle: String = EMPTY_STRING
 
    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    var body: some View
    {
        HStack(alignment: .top)
        {
            Text("ID: \(project.id?.uuidString ?? "None")")
                .fontWeight(.semibold)
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
                    TextInputFieldWithFocus("Category", text: $categoryTitle, isFocused: $isFocused)
                        .padding(8)
                }
                
                Button(action:
                {
                    // if there is a category with the specified title
                    // the use case is added to that category
                    // otherwise, a category is created
                    // and the use case is added
                    /*if let targetCategory = categories.first(where: { $0.title == categoryTitle })
                    {
                        return
                    }
                    else
                    {
                        let categoryToAdd = Category(title: categoryTitle)
                        CategoryManager.shared.addCategory(project: project, category: categoryToAdd)
                    }*/
                    categoryTitle = EMPTY_STRING
                    isFocused = false
                })
                {
                    Text("Add Category").foregroundColor(categoryTitle.isEmpty ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(categoryTitle.isEmpty)
            }.padding()
        }
        Spacer()
        //CategoryListView(project: project)
        Spacer()
            .navigationTitle("project.title.shorten(by: DISP_SHORT)")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProjectDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let project = Project()
        ProjectDetailsView(project: project)
    }
}
