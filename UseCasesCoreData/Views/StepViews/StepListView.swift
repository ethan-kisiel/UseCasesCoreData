//
//  StepListView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import SwiftUI

struct StepListView: View
{
    @State var useCase: UseCase
    

    var body: some View
    {
    
        /*
        if useCaseSteps.isEmpty
        {
            Text("No steps to display.")
        }
        else
        {
            List
            {
                ForEach(useCaseSteps, id: \._id)
                {
                    step in
                    StepCellView(step: step)
                }.onDelete
                {
                    indexSet in
                    indexSet.forEach
                    {
                        index in
                        StepManager.shared.deleteStep(step: useCaseSteps[index])
                    }
                }
            }
            .listStyle(.plain)
            .padding()
        }*/
        Text("Hello World")
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
