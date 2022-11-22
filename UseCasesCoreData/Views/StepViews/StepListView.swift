//
//  StepListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import SwiftUI

struct StepListView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [])
    var steps: FetchedResults<StepEntity>

    let useCase: UseCaseEntity

    var body: some View
    {
        if useCase.wrappedSteps.isEmpty
        {
            Text("No steps to display.")
        }
        else
        {
            List
            {
                ForEach(useCase.wrappedSteps, id: \.id)
                {
                    step in
                    StepCellView(step: step)
                        .swipeActions(edge: .leading)
                    {
                        NavigationLink(value: Route.editStep(step))
                        {
                            Text("Edit")
                        }
                    }.tint(.indigo)
                }.onDelete(perform: deleteStep)
                    .listRowBackground(NM_MAIN)
            }
            .listStyle(.plain)
            .padding()
            .scrollContentBackground(.hidden)
        }
    }
    
    private func deleteStep(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map
            { useCase.wrappedSteps[$0] }.forEach(moc.delete)
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

struct StepListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let context = PersistenceController.shared.container.viewContext
        let useCase = UseCaseEntity(context: context)
        StepListView(useCase: useCase)
    }
}
