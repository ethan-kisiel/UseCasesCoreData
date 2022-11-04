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
    
    @FetchRequest var useCaseSteps: FetchedResults<Step>

    let useCase: UseCase

    init(useCase: UseCase)
    {
        self.useCase = useCase
        _useCaseSteps = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Step.name, ascending: true)],
        predicate: NSPredicate(format: "parent == %@", useCase),
        animation: .default)
    }

    var body: some View
    {
        if useCaseSteps.isEmpty
        {
            Text("No steps to display.")
        }
        else
        {
            List
            {
                ForEach(useCaseSteps, id: \.id)
                {
                    step in
                    StepCellView(step: step)
                }.onDelete(perform: deleteStep)
            }
            .listStyle(.plain)
            .padding()
        }
    }
    
    private func deleteStep(indexSet: IndexSet)
    {
        withAnimation
        {
            indexSet.map { useCaseSteps[$0] }.forEach(moc.delete)
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
        let useCase = UseCase(context: context)
        StepListView(useCase: useCase)
    }
}
