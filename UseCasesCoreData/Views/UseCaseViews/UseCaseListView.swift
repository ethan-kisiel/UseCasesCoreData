//
//  UseCasesListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/10/22.
//

import SwiftUI
enum Sections: String, CaseIterable
{
    case incomplete
    case complete
}

struct UseCaseListView: View
{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var categoryUseCases: FetchedResults<UseCase>
    // takes category for filter query purposes
    private let category: Category
    
    init(category: Category)
    {
        self.category = category
        _categoryUseCases = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath:\UseCase.name, ascending: true)], predicate: NSPredicate(format: "parent == %@", category), animation: .default)
    }
    var completeUseCases: [UseCase]
    {
        return categoryUseCases.filter({ $0.isComplete == true })
    }
    
    var incompleteUseCases: [UseCase]
    {
        return categoryUseCases.filter({ $0.isComplete == false })
    }
    
    var body: some View
    {
        List
        {
            ForEach(Sections.allCases, id: \.self)
            {
                section in
                let filteredCases = section == .incomplete ? incompleteUseCases : completeUseCases
                Spacer()
                Section
                {
                    if filteredCases.isEmpty
                    {
                        Text("No \(section.rawValue) use cases to display.")
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                    }
                    else
                    {
                        switch section
                        {
                        case .incomplete:
                            Text("Incomplete use cases:")
                                .fontWeight(.semibold)
                                .opacity(0.5)
                        case .complete:
                            Text("Complete use cases:")
                                .fontWeight(.semibold)
                                .opacity(0.5)
                        }
                        
                        ForEach(filteredCases, id: \.self)
                        { useCase in
                            //Text("\(useCase.name ?? "NO NAME")")
                            UseCaseCellView(useCase: useCase)
                                .swipeActions(edge: .leading)
                                {
                                    NavigationLink(value: Route.editUseCase(useCase))
                                    {
                                        Text("Edit")
                                    }
                                }.tint(.indigo)
                        }
                        .onDelete(perform: deleteUseCase)
                        .listRowBackground(NM_MAIN)
                    }
                }
            }.listRowBackground(NM_MAIN)
        }
        .listStyle(.plain)
        .padding()
        .scrollContentBackground(.hidden)
    }
    
    private func deleteUseCase(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map { categoryUseCases[$0] }.forEach(moc.delete)
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

struct UseCasesListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let category: Category = Category()
        UseCaseListView(category: category)
    }
}
