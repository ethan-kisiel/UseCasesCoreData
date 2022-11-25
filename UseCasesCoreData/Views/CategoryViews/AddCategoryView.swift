//
//  AddCategoryView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/17/22.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var project: ProjectEntity

    @State private var title: String = EMPTY_STRING

    @FocusState var isFocused: Bool
    
    private var invalidFields: Bool
    {
        title.isEmpty
    }

    var body: some View {
        VStack(spacing: 5)
        {
            withAnimation
            {
                TextBoxWithFocus("Category", text: $title, isFocused: $isFocused)
                    .padding(8)
            }
            
            Button(action:
                    {
                // if there is a category with the specified title
                // the use case is added to that category
                // otherwise, a category is created
                // and the use case is added
                addCategory()
                
                title = EMPTY_STRING
                isFocused = false
            })
            {
                Text("Add Category").foregroundColor(invalidFields ? .secondary: NM_SEC)
                    .fontWeight(.bold).frame(maxWidth: .infinity)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
            .disabled(invalidFields)
            .padding(8)
        }.padding()
    }

    func addCategory()
    {
        let category = CategoryEntity(context: moc)
    
        //category.id = UUID()
        category.dateCreated = Date()
        category.lastUpdated = Date()
        category.title = title
        project.addToCategories(category)

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

struct AddCategoryView_Previews: PreviewProvider {

    static var previews: some View {
        //AddCategoryView(project: ProjectEntity(), refreshTopView: $refrsh)
        Text("Preview")
    }
}
