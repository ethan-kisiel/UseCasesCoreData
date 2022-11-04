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
    
    let useCase: UseCase
    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    @State var name: String = EMPTY_STRING
    @State var text: String = EMPTY_STRING
    @State var stepId: String = EMPTY_STRING

    var body: some View
    {
        HStack(alignment: .top)
        {
            Text("**\(useCase.name ?? EMPTY_STRING)** Steps:")
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
                    TextInputFieldWithFocus("Step", text: $name, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextInputFieldWithFocus("ID", text: $stepId, isFocused: $isFocused).padding(8)
                }

                Button(action:
                    {
                        addStep()

                        name = EMPTY_STRING
                        stepId = EMPTY_STRING
                        isFocused = false
                    })
                {
                    Text("Add Step").foregroundColor(text.isEmpty ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(name.isEmpty)
            }.padding()
        }
        Spacer()
        StepListView(useCase: useCase)
            .environment(\.managedObjectContext, moc)
        Spacer()
            .navigationTitle("Steps")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addStep()
    {
        withAnimation
        {
            let step = Step(context: moc)
            step.id = UUID()
            step.name = name
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
