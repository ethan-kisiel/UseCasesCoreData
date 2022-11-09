//
//  StepDetailsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/5/22.
//

import SwiftUI

struct StepDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var step: Step

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Step.name, ascending: true)], animation: .default)
    var steps: FetchedResults<Step>
    
    var filteredSteps: [Step]
    {
        return steps.filter({ $0.parent == step.parent })
    }

    var body: some View {
        VStack
        {
            HStack
            {
                Menu
                {
                    Picker(selection: $step,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(filteredSteps, id: \.self)
                        { step in
                            Text(step.name ?? "No Name")
                        }
                    })
                } label:
                {
                    Text("Step: **\(step.name!)**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }
                Spacer()
            }.padding()
            Spacer()
            VStack
            {
                Text(step.body!)
            }
            Spacer()
                .navigationTitle("Step Details")
        }.background(NM_MAIN)
    }
}

struct StepDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //StepDetailsView()
        Text("DetailsPreview")
    }
}
