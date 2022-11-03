//
//  CategoryListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/7/22.
//

import SwiftUI
/*
struct CategoryListView: View {
    @State var project: Project
    @ObservedResults(Category.self) var categories: Results<Category>
    
    var projectCategories: Results<Category>
    {
        categories.where { $0.parentProject._id == project._id }
    }
    @State var showUseCases: Bool = false
    var body: some View {
        List
        {
            ForEach(projectCategories, id: \._id)
            { category in
                CategoryCellView(category: category)
            }
            .onDelete
            { indexSet in
                indexSet.forEach
                { index in
                    CategoryManager.shared.deleteCategory(projectCategories[index])
                }
                
            }
        }
        .listStyle(.plain)
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(project: Project())
    }
}
*/
