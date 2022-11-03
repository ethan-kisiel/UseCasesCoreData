//
//  CategoryCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/11/22.
//

import CoreData
import SwiftUI
/*
struct CategoryCellView: View {
    let category: Category
    @State var trashIsEnabled: Bool = false
    var body: some View
    {
        NavigationLink(value: Route.category(category))
        {
            HStack(alignment: .center)
            {
                Image(systemName: TRASH_ICON).foregroundColor(trashIsEnabled ? .red : .gray)
                    .disabled(trashIsEnabled)
                    .onLongPressGesture(minimumDuration: 0.8)
                {
                    trashIsEnabled.toggle()
                }
                .onTapGesture
                {
                    if trashIsEnabled
                    {
                        CategoryManager.shared.deleteCategory(category)
                    }
                }
                Text(category.title)
                Spacer()
                // TODO: change this to user made category id
                let categoryId = category._id.stringValue
                Text(categoryId.shorten(by: 3))
            }
        }
    }
}

struct CategoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCellView(category: Category(title: "Preview"))
    }
}
*/
