//
//  CategoryListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/7/22.
//

import CoreData
import SwiftUI

struct CategoryListView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [])
    private var categories: FetchedResults<CategoryEntity>
    
    @State private var isDeletePresented: Bool = false
    
    @State var project: ProjectEntity
    
    var body: some View
    {
        VStack
        {
            if project.wrappedCategories.isEmpty
            {
                Text("No categories to show.")
            }
            else
            {
                List
                {
                    ForEach(project.wrappedCategories, id: \.id)
                    { category in
                        CategoryCellView(category: category)
                            .swipeActions(edge: .trailing)
                            {
                                Button(ALERT_DEL)
                                {
                                    isDeletePresented = true
                                    print("DELETED")
                                }
                            }.tint(.red)
                            .alert(isPresented: $isDeletePresented)
                            {
                                Alert(
                                    title: Text("Do you wish to delete this category?"),
                                    message: Text("Doing so will delete this category and all of its children."),
                                    primaryButton: .destructive(Text(ALERT_DEL), action:
                                    {
                                        deleteCategory(category)
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                            .swipeActions(edge: .trailing)
                            {
                                NavigationLink(value: Route.editCategory(category))
                                {
                                    Text("Edit")
                                }
                            }.tint(.indigo)
                    }
                    .onDelete
                    { indexSet in
                    }

                    .listRowBackground(NM_MAIN)
                }.listStyle(.plain)
                .padding()
                .scrollContentBackground(.hidden)
            }
        }.background(NM_MAIN)
    }

    private func deleteCategory(_ category: CategoryEntity)
    {
        moc.delete(category)
        
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

struct CategoryListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CategoryListView(project: ProjectEntity())
    }
}
