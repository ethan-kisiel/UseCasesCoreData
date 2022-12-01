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
    @FetchRequest(sortDescriptors: [])
    var useCases: FetchedResults<UseCaseEntity>
    
    // takes category for filter query purposes
    let category: CategoryEntity
    
    @State private var isDeletePresented: Bool = false
    @State private var indexSet: IndexSet = IndexSet()

    var body: some View
    {
        VStack
        {
            if category.wrappedUseCases.isEmpty
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
                    ForEach(category.wrappedUseCases, id: \.self)
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
                                    deleteUseCase(indexSet: indexSet)
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
        }.padding(8)
    }
    
    private func deleteUseCase(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map { category.wrappedUseCases[$0] }.forEach(moc.delete)
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
