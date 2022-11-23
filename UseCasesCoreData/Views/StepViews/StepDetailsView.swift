//
//  StepDetailsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/5/22.
//

import SwiftUI

struct StepDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @State var step: StepEntity

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \StepEntity.title, ascending: true)], animation: .default)
    var steps: FetchedResults<StepEntity>
    
    var filteredSteps: [StepEntity]
    {
        return steps.filter({ $0.useCase == step.useCase })
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
                            Text(step.wrappedTitle)
                        }
                    })
                } label:
                {
                    Text("Step: **\(step.wrappedTitle)**")
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
            ReturnToTopButton()
        }.background(NM_MAIN)
    }
}

struct StepDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //StepDetailsView()
        Text("DetailsPreview")
    }
}
