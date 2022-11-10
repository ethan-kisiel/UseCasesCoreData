//
//  CategoryDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/29/22.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var category: Category
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    private var filteredCategories: [Category]
    {
        return categories.filter({ $0.parent == category.parent })
    }
    
    @State var priority: Priority = .medium
    @State var title: String = EMPTY_STRING
    @State var caseId: String = EMPTY_STRING
    // add inline picker for the category selection
    
    @State var useCase: UseCase?

    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Menu
                {
                    Picker(selection: $category,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(filteredCategories, id: \.self)
                        { category in
                            Text(category.wrappedName)
                        }
                    })
                } label:
                {
                    Text("Category: **\(category.wrappedName)**")
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
                    Picker("Priority:", selection: $priority)
                    {
                        ForEach(Priority.allCases, id: \.self)
                        {
                            priority in
                            Text(priority.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(5)
                    
                    withAnimation
                    {
                        TextBoxWithFocus("Use Case", text: $title, isFocused: $isFocused).padding(8)
                    }
                    withAnimation
                    {
                        TextBoxWithFocus("ID", text: $caseId, isFocused: $isFocused).padding(8)
                    }
                    
                    Button(action:
                            {
                        addUseCase()
                        
                        title = EMPTY_STRING
                        caseId = EMPTY_STRING
                        priority = .medium
                        isFocused = false
                    })
                    {
                        Text("Add Use Case").foregroundColor(title.isEmpty || caseId.isEmpty ? .secondary : .primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .disabled(title.isEmpty || caseId.isEmpty )
                    .padding(8)
                }.padding()
            }
        
            Spacer()
            UseCaseListView(category: category)
            Spacer()
                .navigationTitle("Use Cases")
                .navigationBarTitleDisplayMode(.inline)
        }.background(NM_MAIN)
    }
    
    private func addUseCase()
    {
        withAnimation
        {
            let useCase = UseCase(context: moc)
            useCase.id = UUID()
            useCase.name = title
            useCase.priority = priority.rawValue
            useCase.isComplete = false
            useCase.created = Date()
            useCase.lastUpdated = useCase.created
            useCase.parent = category

            do
            {
                try moc.save()
                print("Successfully saved use case")
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //CategoryDetailsView(category: Category(title: "Preview"))
        Text("None")
    }
}
