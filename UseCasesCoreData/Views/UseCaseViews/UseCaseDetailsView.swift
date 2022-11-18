//
//  UseCaseDetailsView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import Neumorphic
import SwiftUI

struct UseCaseDetailsView: View
{
    @Environment(\.managedObjectContext) var moc

    @State var useCase: UseCase
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UseCase.title, ascending: true)], animation: .default)
    private var useCases: FetchedResults<UseCase>
    private var filteredUseCases: [UseCase]
    {
        return useCases.filter({ $0.parent == useCase.parent })
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
                Image(systemName: showAddFields ? LESS_ICON : MORE_ICON)
                    .onTapGesture
                {
                    showAddFields.toggle()
                }
            }.padding()
            
            if showAddFields
            {
                AddStepView(useCase: useCase)
            }
            Spacer()
            StepListView(useCase: useCase)
            Spacer()
                .navigationTitle("Steps")
                .navigationBarTitleDisplayMode(.inline)
            ReturnToTopButton()
        }.background(NM_MAIN)
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
