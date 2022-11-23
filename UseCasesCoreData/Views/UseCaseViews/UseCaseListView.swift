//
//  UseCasesListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/10/22.
//

import SwiftUI
enum Sections: String, CaseIterable
{
    case incomplete = "Incomplete"
    case complete = "Complete"
}

struct UseCaseListView: View
{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var categoryUseCases: FetchedResults<UseCaseEntity>
    // takes category for filter query purposes
    private let category: CategoryEntity
    
    @State private var alertIsPresented: Bool = false
    @State private var indexSet: IndexSet = IndexSet()
    @State private var currentSection: Sections = .incomplete

    init(category: CategoryEntity)
    {
        self.category = category
        _categoryUseCases = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UseCaseEntity.prioritySort, ascending: true)], predicate: NSPredicate(format: "parent == %@", category), animation: .default)
    }
    var completeUseCases: [UseCaseEntity]
    {
        return categoryUseCases.filter({ $0.isComplete == true })
    }
    
    var incompleteUseCases: [UseCaseEntity]
    {
        return categoryUseCases.filter({ $0.isComplete == false })
    }

    var body: some View
    {
        VStack
        {
            Picker("Complete/Incomplete:", selection: $currentSection)
            {
                ForEach(Sections.allCases, id: \.self)
                { section in
                    Text(section.rawValue)
                }
            }
            .pickerStyle(.segmented)

            let filteredCases = currentSection == .incomplete ? incompleteUseCases : completeUseCases
            Spacer()
            if filteredCases.isEmpty
            {
                Text("No \(currentSection.rawValue) use cases to display.")
                    .foregroundColor(.secondary)
                    .opacity(0.5)
                Spacer()
            }
            else
            {
                switch currentSection
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
                List
                {
                    ForEach(filteredCases, id: \.self)
                    { useCase in
                        UseCaseCellView(useCase: useCase)
                            .swipeActions(edge: .leading)
                        {
                            NavigationLink(value: Route.editUseCase(useCase))
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
                            title: Text("Do you wish to delete this use case?"),
                            message: Text("Doing so will delete this use case and all of its children."),
                            primaryButton: .destructive(Text("Delete"), action: {
                                deleteUseCase(indexSet: indexSet)
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                    .listRowBackground(NM_MAIN)
                }
                .listStyle(.plain)
                .padding()
                .scrollContentBackground(.hidden)
            }
        }.padding(8)
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
        let category: CategoryEntity = CategoryEntity()
        UseCaseListView(category: category)
    }
}
