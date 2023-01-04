//
//  CategoryFieldsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/30/22.
//

import SwiftUI

struct CategoryFieldsView: View {
    @Environment(\.managedObjectContext) var moc

    @Environment(\.dismiss) var dismiss
    
    @State var title: String = EMPTY_STRING
    
    @State var description: String = EMPTY_STRING
    
    @FocusState var isFocused: Bool
    
    private let category: CategoryEntity?
    
    private let project: ProjectEntity?
    
    private let isNewCategory: Bool
    
    init(_ category: CategoryEntity? = nil, project: ProjectEntity? = nil)
    {
        // if a category is passed, project is initialized as nil
        // if a project is passed, category is initialized as nil
        

        if let category = category
        {
            self.category = category

            self.project = nil
            
            isNewCategory = false
            
            // initialization happens here, so that the state values
            // which are used as bindings for the text fields
            // can be set to the values of the passed project
            
            _title = State(wrappedValue: category.wrappedTitle)
            
            _description = State(wrappedValue: category.desc ?? EMPTY_STRING)
        }
        else
        {
            self.category = nil
            
            self.project = project
            
            isNewCategory = true
        }
    }
    
    var invalidFields: Bool
    {
        title.isEmpty || description.isEmpty
    }
    
    var body: some View
    {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                withAnimation
                {
                    TextBoxWithFocus("Title", text: $title, isFocused: $isFocused)
                        .padding(8)
                }
                
                withAnimation
                {
                    TextEditorWithFocus("Description", text: $description, isFocused: $isFocused)
                        .padding(8)
                }
                
                HStack
                {
                    Button(action:
                            {
                        
                        isNewCategory ? addCategory() : updateCategory(category!)
                        
                        title = EMPTY_STRING
                        description = EMPTY_STRING

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
                    
                    Button(action:
                            {
                        dismiss()
                    })
                    {
                        Text("Cancel").foregroundColor(.primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .padding(8)
                }
                
                Spacer()
                  
            }.background(NM_MAIN)
                .padding()
            
        }
        .navigationTitle("\(isNewCategory ? "Add" : "Edit") Category")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addCategory()
    {
        let category = CategoryEntity(context: moc)
    
        category.id = EntityIdUtil.shared
            .getNewObjectId(CategoryEntity.self)

        category.dateCreated = Date()
        category.lastUpdated = category.dateCreated

        
        category.title = title
        category.desc = description

        if let userId = UserInfoUtil.shared.getUserId()
        {
            category.createdBy = userId
        }

        project?.addToCategories(category)

        do
        {
            try moc.save()
        }
        catch
        {
            Log.error("Failed to save managed object context.")
        }
    }

    private func updateCategory(_ category: CategoryEntity)
    {
        category.title = title
        category.desc = description
        category.lastUpdated = Date()

        do
        {
            try moc.save()
        }
        catch
        {
            Log.error("Failed to save managed object context.")
        }
    }
}

struct CategoryFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFieldsView()
    }
}
