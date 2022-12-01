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
                        .swipeActions(edge: .trailing)
                    {
                        Button(ALERT_DEL)
                        {
                            deleteStep(step)
                        }
                    }.tint(.red)
                        .swipeActions(edge: .trailing)
                    {
                        NavigationLink(value: Route.editStep(step))
                        {
                            Text("Edit")
                        }
                    }.tint(.indigo)
                }.onDelete
                { indexSet in
                    
                }
                    .listRowBackground(NM_MAIN)
            }
            .listStyle(.plain)
            .padding()
            .scrollContentBackground(.hidden)
        }
    }
    
    private func deleteStep(_ step: StepEntity)
    {
        withAnimation
        {
            moc.delete(step)
        }
        
        do
        {
            try moc.save()
        }
        catch
        {
            
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
