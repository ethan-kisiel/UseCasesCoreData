//
//  CategoryDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 8/29/22.
//

import SwiftUI

struct UseCasesView: View {
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var router: Router
    
    @State var category: CategoryEntity
    
    @State var searchText: String = EMPTY_STRING
    
    @State var sortKey: SortType = .title
    
    @State var isDeletePresented: Bool = false
    
    private var sortedCategories: [CategoryEntity]
    {
        return category.project?.wrappedCategories.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        } ?? []
    }
    
    private var filteredUseCases: [UseCaseEntity]
    {
        let sortedUseCases = category.wrappedUseCases.sorted
        {
            switch sortKey
            {
            case .title:
                return $0.wrappedTitle < $1.wrappedTitle
            case .lastUpdated:
                return $0.wrappedDate > $1.wrappedDate
            }
        }
        
        if searchText.isEmpty
        {
            return sortedUseCases
        }
        
        switch sortKey
        {
        case .title:
            return sortedUseCases.filter
            {
                $0.wrappedTitle.lowercased()
                    .contains(searchText.lowercased())
            }
        case .lastUpdated:
            return sortedUseCases.filter
            {
                $0.wrappedDate.lowercased()
                    .contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                VStack(alignment: .leading)
                {
                    DiscretePicker(displayText: "Sort by: ", selection: $sortKey, selectables: SortType.allCases, keyPath: \SortType.rawValue)
    
                    DiscretePicker(displayText: "Category: ", selection: $category, selectables: sortedCategories, keyPath: \CategoryEntity.wrappedTitle)
                }
                .padding(.leading)
                
                Spacer()
            }
            
            Spacer()
            
            if filteredUseCases.isEmpty
            {
                
                Text("No use cases to display.")
                    .foregroundColor(.secondary)
                    .opacity(0.5)
                
                Spacer()
            }
            else
            {
                List
                {
                    ForEach(filteredUseCases, id: \.self)
                    { useCase in
                        UseCaseCellView(useCase: useCase)
                            .swipeActions(edge: .trailing)
                        {
                            Button(ALERT_DEL)
                            {
                                isDeletePresented = true
                            }
                        }.tint(.red)
                            .alert(isPresented: $isDeletePresented)
                        {
                            Alert(
                                title: Text("Do you wish to delete this use case?"),
                                message: Text("Doing so will delete this use case and all of its children."),
                                primaryButton: .destructive(Text(ALERT_DEL), action: {
                                    deleteUseCase(useCase)
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                        
                        .swipeActions(edge: .trailing)
                        {
                            NavigationLink(value: Route.editUseCase(useCase))
                            {
                                Text("Edit")
                            }
                        }.tint(.indigo)
                    }
                    .onDelete
                    { indexSet in
                    }
                    .listRowBackground(NM_MAIN)
                }
                .listStyle(.plain)
                .padding()
                .scrollContentBackground(.hidden)
            }
        }
            .background(NM_MAIN)
            .navigationTitle("Use Cases")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
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
            
            ToolbarItemGroup(placement: .bottomBar)
            {
                ReturnToButtons()
                    .padding(.bottom)
            }
        }
    }
    
    private func deleteUseCase(_ useCase: UseCaseEntity)
    {
        withAnimation
        {
            moc.delete(useCase)
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


struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //CategoryDetailsView(category: Category(title: "Preview"))
        Text("None")
    }
}

/*
    
        .background(NM_MAIN)
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
*/
