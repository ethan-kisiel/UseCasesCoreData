//
//  UseCaseDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import Neumorphic
import SwiftUI

struct StepsView: View
{
    @Environment(\.managedObjectContext) var moc

    @State var useCase: UseCaseEntity
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UseCaseEntity.title, ascending: true)], animation: .default)
    private var useCases: FetchedResults<UseCaseEntity>
    private var filteredUseCases: [UseCaseEntity]
    {
        return useCases.filter({ $0.category == useCase.category })
    }
    
    @State var showAddFields: Bool = false
    
    var body: some View
    {
        VStack
        {
            HStack(alignment: .top)
            {
                Menu
                {
                    Picker(selection: $useCase,
                           label: EmptyView(),
                           content:
                            {
                        ForEach(filteredUseCases, id: \.self)
                        { useCase in
                            Text(useCase.wrappedTitle)
                        }
                    })
                } label:
                {
                    Text("Use Case: **\(useCase.wrappedTitle)**")
                        .background(NM_MAIN)
                        .foregroundColor(NM_SEC)
                }

                Spacer()

            }.padding()
            
            Spacer()
            
            StepListView(useCase: useCase)
            
            Spacer()

            ReturnToButtons()

        }.background(NM_MAIN)
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar
            {
                ToolbarItemGroup(placement: .navigationBarTrailing)
                {
                    useCase.wrappedSteps.count > 0 ? EditButton() : nil
                    
                    NavigationLink(value: Route.addStep(useCase))
                    {
                        Image(systemName: ADD_ICON)
                    }
                }
            }
    }
}

struct UseCaseDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //let useCase = UseCase(title: "title", priority: .medium)
        //UseCaseDetailsView()
        Text("Preview")
    }
}
