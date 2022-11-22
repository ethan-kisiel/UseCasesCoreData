//
//  CategoryListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/7/22.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var projectCategories: FetchedResults<CategoryEntity>
    
    private let project: ProjectEntity
    
    @State private var showUseCases: Bool = false
    
    @State private var alertIsPresented: Bool = false
    @State private var indexSet: IndexSet = IndexSet()
    
    init(project: ProjectEntity)
    {
        self.project = project
        _projectCategories = FetchRequest<CategoryEntity>(
            sortDescriptors: [NSSortDescriptor(keyPath: \CategoryEntity.title, ascending: true)],
            predicate: NSPredicate(format: "parent == %@", project),
            animation: .default)
    }
    
    var body: some View {
        VStack
        {
            if projectCategories.isEmpty
            {
                Text("No categories to show.")
            }
            else
            {
                List
                {
                    ForEach(projectCategories, id: \.id)
                    { category in
                        CategoryCellView(category: category)
                            .swipeActions(edge: .leading)
                        {
                            NavigationLink(value: Route.editCategory(category))
                            {
                                Text("Edit")
                            }
                        }.tint(.indigo)
                    }
                    .onDelete
                    { indexSet in
                        self.indexSet = indexSet
                        alertIsPresented = true
                    }
                    .alert(isPresented: $alertIsPresented)
                    {
                        Alert(
                            title: Text("Do you wish to delete this category?"),
                            message: Text("Doing so will delete this category and all of its children."),
                            primaryButton: .destructive(Text("DELETE"), action: {
                                deleteCategory(indexSet: indexSet)
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                    .listRowBackground(NM_MAIN)
                }.listStyle(.plain)
                    .padding()
                    .scrollContentBackground(.hidden)
            }
        }.background(NM_MAIN)
    }
    private func deleteCategory(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map{ projectCategories[$0] }.forEach(moc.delete)
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

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let moc = PersistenceController.shared.container.viewContext
        CategoryListView(project: ProjectEntity(context: moc))
    }
}
