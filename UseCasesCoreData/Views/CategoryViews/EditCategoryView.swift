//
//  EditCategoryView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/9/22.
//

import SwiftUI

struct EditCategoryView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    let category: CategoryEntity
    @State var title: String
    @State var categoryId: String
    
    @FocusState var isFocused: Bool
    
    init(category: CategoryEntity)
    {
        self.category = category
        _title = State(wrappedValue: category.wrappedTitle)
        //_categoryId = State(wrappedValue: category.wrappedId)
        _categoryId = State(wrappedValue: "")
    }

    var invalidFields: Bool
    {
        title.isEmpty || categoryId.isEmpty
    }

    var body: some View {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                Text(category.wrappedTitle)
                withAnimation
                {
                    TextBoxWithFocus("Category Name", text: $title, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextBoxWithFocus("Category ID", text: $categoryId, isFocused: $isFocused).padding(8)
                }
                
                Button(action:
                        {
                    updateCategory(category)
                    
                    title = EMPTY_STRING
                    categoryId = EMPTY_STRING
                    isFocused = false
                    dismiss()
                })
                {
                    Text("Save Category").foregroundColor(invalidFields ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(invalidFields)
                .padding(8)
                
                Spacer()
                    .navigationTitle("Edit Category")
                    .navigationBarTitleDisplayMode(.inline)
            }.background(NM_MAIN)
                .padding()
        }
    }
    
    private func updateCategory(_ category: CategoryEntity)
    {
        category.title = title
        category.lastUpdated = Date()
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

struct EditCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        EditCategoryView(category: CategoryEntity())
    }
}
