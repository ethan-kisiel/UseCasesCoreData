//
//  StepCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import SwiftUI

struct StepCellView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var steps: FetchedResults<StepEntity>
    
    let step: StepEntity
    @State var trashIsEnabled: Bool = false
    var body: some View
    {
        NavigationLink(value: Route.step(step))
        {
            VStack(spacing: 8)
            {
                HStack(alignment: .center)
                {
                    Text(step.wrappedTitle)
                    
                    Spacer()
                }
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text("**Created on:** \(step.wrappedDate)")
                            .font(.caption)
                        Text("**Last updated:** \(step.wrappedDate)")
                            .font(.caption)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private func deleteStep(_ step: StepEntity)
    {
        if let deleteIndex = steps.firstIndex(where: { $0.id == step.id })
        {
            withAnimation
            {
                moc.delete(steps[deleteIndex])
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
}

struct StepCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //let step = Step(text: "")
        //StepCellView(step: step)
        Text("Preview")
    }
}
