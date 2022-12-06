//
//  CategoryDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/29/22.
//

import SwiftUI

struct CategoryUseCasesView: View {
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var router: Router
    
    @State var category: CategoryEntity

    @State var showAddFields: Bool = false

    private var projectCategories: [CategoryEntity]
    {
        return category.project?.wrappedCategories ?? []
    }

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
                        ForEach(projectCategories, id: \.self)
                        { category in
                            Text(category.wrappedTitle)
                        }
                    })
                } label:
                {
                    Text("Category: **\(category.wrappedTitle)**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }

                Spacer()

            }.padding()
        
            Spacer()
            
            UseCaseListView(category: category)
            
            Spacer()

            ReturnToButtons()

        }.background(NM_MAIN)
            .navigationTitle("Use Cases")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItemGroup(placement: .navigationBarTrailing)
                {
                    HStack
                    {
                        category.wrappedUseCases.count > 0 ? EditButton() : nil
                        
                        NavigationLink(value: Route.addUseCase(category))
                        {
                            Image(systemName: ADD_ICON)
                        }
                    }
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
