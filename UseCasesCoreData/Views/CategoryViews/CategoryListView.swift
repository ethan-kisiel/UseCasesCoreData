//
//  CategoryListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/7/22.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest var projectCategories: FetchedResults<Category>
    
    private let project: Project
    
    @State private var showUseCases: Bool = false
    
    init(project: Project)
    {
        self.project = project
        _projectCategories = FetchRequest<Category>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
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
                    .onDelete(perform: deleteCategory)
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
        CategoryListView(project: Project(context: moc))
    }
}
