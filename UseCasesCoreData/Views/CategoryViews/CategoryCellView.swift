//
//  CategoryCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/11/22.
//

import CoreData
import SwiftUI

struct CategoryCellView: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
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
                .onTapGesture
                {
                    if trashIsEnabled
                    {
                        deleteCategory(category)
                    }
                }
                .onLongPressGesture(minimumDuration: 0.8)
                {
                    trashIsEnabled.toggle()
                }
                Text(category.wrappedName)
                Spacer()
                // TODO: change this to user made category id
                let categoryId = category.wrappedId
                Text(categoryId.shorten(by: 3) + "...")
            }
        }
    }
    
    private func deleteCategory(_ category: Category)
    {
        if let deleteIndex = categories.firstIndex(where: { $0.id == category.id })
        {
            withAnimation
            {
                moc.delete(categories[deleteIndex])
            }
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
}

struct CategoryCellView_Previews: PreviewProvider {
    static var previews: some View {
        //CategoryCellView(category: Category(title: "Preview"))
        Text("Preview")
    }
}
