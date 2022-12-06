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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.title, ascending: true)], animation: .default)
    private var categories: FetchedResults<CategoryEntity>
    
    let category: CategoryEntity
    @State var trashIsEnabled: Bool = false
    var body: some View
    {
        NavigationLink(value: Route.category(category))
        {
            VStack(alignment: .leading, spacing: 5)
            {
                HStack(alignment: .center)
                {
                    Text(category.wrappedTitle)
                        .bold()
                    
                }
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text(category.wrappedDescription)
                            .font(.caption)
                        Text("**Last updated:** \(category.wrappedDate)")
                            .font(.caption)
                    }
                    
                }
            }
        }
    }
    
    private func deleteCategory(_ category: CategoryEntity)
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
