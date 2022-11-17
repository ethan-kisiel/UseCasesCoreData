//
//  AddCategoryView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/17/22.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) var moc
    
    let project: Project

    @State private var categoryTitle: String = EMPTY_STRING
    @State private var categoryId: String = EMPTY_STRING
    
    @FocusState var isFocused: Bool
    
    private var invalidFields: Bool
    {
        categoryTitle.isEmpty
    }

    var body: some View {
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
                addCategory()
                
                categoryTitle = EMPTY_STRING
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
        let category = Category(context: moc)
        category.id = UUID()
        category.created = Date()
        category.lastUpdated = Date()
        category.name = categoryTitle
        category.customId = categoryId
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

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(project: Project())
    }
}
