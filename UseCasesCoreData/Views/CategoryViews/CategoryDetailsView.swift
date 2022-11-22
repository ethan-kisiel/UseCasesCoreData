//
//  CategoryDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/29/22.
//

import SwiftUI

struct CategoryDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var router: Router
    
    @State var category: CategoryEntity
    @State var showAddFields: Bool = false

    private var filteredCategories: [CategoryEntity]
    {
        return category.parent?.wrappedCategories ?? []
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
                        ForEach(filteredCategories, id: \.self)
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
                Image(systemName: showAddFields ? LESS_ICON : MORE_ICON)
                    .onTapGesture
                {
                    showAddFields.toggle()
                }
            }.padding()
            
            if showAddFields
            {
                AddUseCaseView(category: category)
            }
        
            Spacer()
            UseCaseListView(category: category)
            Spacer()
                .navigationTitle("Use Cases")
                .navigationBarTitleDisplayMode(.inline)
            ReturnToTopButton()
        }.background(NM_MAIN)
    }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //CategoryDetailsView(category: Category(title: "Preview"))
        Text("None")
    }
}
