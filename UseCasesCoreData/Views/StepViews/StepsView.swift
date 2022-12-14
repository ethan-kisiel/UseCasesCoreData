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

struct UseCaseDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //let useCase = UseCase(title: "title", priority: .medium)
        //UseCaseDetailsView()
        Text("Preview")
    }
}
