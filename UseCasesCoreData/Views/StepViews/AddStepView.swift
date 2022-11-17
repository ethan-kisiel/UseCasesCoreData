//
//  AddStepView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/17/22.
//

import SwiftUI

struct AddStepView: View {
    @Environment(\.managedObjectContext) var moc
    
    let useCase: UseCase

    @State private var name: String = EMPTY_STRING
    @State private var text: String = EMPTY_STRING
    @State private var stepId: String = EMPTY_STRING
    
    @FocusState var isFocused: Bool
    
    private var invalidFields: Bool
    {
        return name.isEmpty && text.isEmpty
    }
    
    var body: some View {
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
                // MARK: add form validation variable
                Text("Add Step").foregroundColor(invalidFields ? .secondary : .primary)
                    .fontWeight(.bold).frame(maxWidth: .infinity)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
            .disabled(invalidFields)
            .padding(8)
        }.padding()
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

struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepView(useCase: UseCase())
    }
}
