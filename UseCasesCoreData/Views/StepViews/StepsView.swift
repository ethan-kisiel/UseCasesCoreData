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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UseCaseEntity.title, ascending: true)], animation: .default)
    private var useCases: FetchedResults<UseCaseEntity>

    @State var useCase: UseCaseEntity
    
    @State var sortKey: SortType = .title
    
    @State var searchText: String = EMPTY_STRING
    
    @State var showAddFields: Bool = false
    
    private var sortedUseCases: [UseCaseEntity]
    {
        let useCases = useCases.filter({ $0.category == useCase.category })
        
        return useCases.sorted
        {
            $0.wrappedTitle < $1.wrappedTitle
        }
    }
    
    private var filteredSteps: [StepEntity]
    {
        let sortedSteps = useCase.wrappedSteps.sorted
        {
            switch sortKey
            {
            case .title:
                return $0.wrappedTitle < $1.wrappedTitle
            case .lastUpdated:
                return $0.wrappedDate > $1.wrappedDate
            }
        }
        
        if searchText.isEmpty
        {
            return sortedSteps
        }
        
        switch sortKey
        {
        case .title:
            return sortedSteps.filter
            {
                $0.wrappedTitle.lowercased()
                    .contains(searchText.lowercased())
            }
        case .lastUpdated:
            return sortedSteps.filter
            {
                $0.wrappedDate.lowercased()
                    .contains(searchText.lowercased())
            }
        }
    }

    var body: some View
    {
        VStack
        {
            HStack
            {
                VStack(alignment: .leading)
                {

                    DiscretePicker(displayText: "Sort by: ", selection: $sortKey, selectables: SortType.allCases, keyPath: \SortType.rawValue)
                    
                    DiscretePicker(displayText: "Use Case: ", selection: $useCase, selectables: sortedUseCases, keyPath: \UseCaseEntity.wrappedTitle)
                }
                .padding(.leading)
                
                Spacer()
            }
            
            Spacer()
            
            if filteredSteps.isEmpty
            {
                Text("No steps to display.")
            }
            else
            {
                List
                {
                    ForEach(filteredSteps, id: \.id)
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

        }.background(NM_MAIN)
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar
            {
                // Navigation tabs
                ToolbarItemGroup(placement: .bottomBar)
                {
                    NavigationBottomBar()
                }
                
                // Add button
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
