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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UseCase.name, ascending: true)], animation: .default)
    private var useCases: FetchedResults<UseCase>
    private var filteredUseCases: [UseCase]
    {
        return useCases.filter({ $0.parent == useCase.parent })
    }
    
    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    @State var name: String = EMPTY_STRING
    @State var text: String = EMPTY_STRING
    @State var stepId: String = EMPTY_STRING
    
    private var invalidFields: Bool
    {
        return name.isEmpty && text.isEmpty
    }
    
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
                            Text(useCase.name ?? "No Name")
                        }
                    })
                } label:
                {
                    Text("Use Case: **\(useCase.name!)**")
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
                VStack(spacing: 5)
                {
                    withAnimation
                    {
                        TextBoxWithFocus("Step", text: $name, isFocused: $isFocused).padding(8)
                    }
                    withAnimation
                    {
                        TextBoxWithFocus("ID", text: $stepId, isFocused: $isFocused).padding(8)
                    }
                    
                    withAnimation
                    {
                        TextBoxWithFocus("Description", text: $text, isFocused: $isFocused).padding(8)
                    }
                    Button(action:
                            {
                        addStep()
                        
                        name = EMPTY_STRING
                        stepId = EMPTY_STRING
                        text = EMPTY_STRING
                        isFocused = false
                    })
                    {
                        Text("Add Step").foregroundColor(text.isEmpty ? .secondary : .primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .disabled(invalidFields)
                    .padding(8)
                }.padding()
            }
            Spacer()
            StepListView(useCase: useCase)
            Spacer()
                .navigationTitle("Steps")
                .navigationBarTitleDisplayMode(.inline)
        }.background(NM_MAIN)
    }
    
    private func addStep()
    {
        withAnimation
        {
            let step = Step(context: moc)
            step.id = UUID()
            step.name = name
            step.body = text
            step.created = Date()
            step.lastUpdated = step.created
            step.parent = useCase
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

struct UseCaseDetailsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //let useCase = UseCase(title: "title", priority: .medium)
        //UseCaseDetailsView()
        Text("Preview")
    }
}
