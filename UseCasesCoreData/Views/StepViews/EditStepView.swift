//
//  EditStepView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/9/22.
//

import SwiftUI

struct EditStepView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    let step: Step
    @State var title: String
    @State var stepId: String
    @State var description: String
    @FocusState var isFocused: Bool
    
    init(step: Step)
    {
        self.step = step
        _title = State(wrappedValue: step.wrappedTitle)
        _stepId = State(wrappedValue: step.wrappedId)
        //TODO: add wrapped body value
        _description = State(wrappedValue: step.body ?? EMPTY_STRING)
    }
    
    var invalidFields: Bool
    {
        title.isEmpty || stepId.isEmpty
    }
    
    var body: some View {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                Text(step.wrappedTitle)
                withAnimation
                {
                    TextBoxWithFocus("Step Name", text: $title, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextBoxWithFocus("Step ID", text: $stepId, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextBoxWithFocus("Description", text: $description, isFocused: $isFocused).padding(8)
                }
                Button(action:
                        {
                    updateStep(step)
                    
                    title = EMPTY_STRING
                    stepId = EMPTY_STRING
                    description = EMPTY_STRING
                    isFocused = false
                    dismiss()
                })
                {
                    Text("Save Step").foregroundColor(invalidFields ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(invalidFields)
                .padding(8)
                
                Spacer()
                    .navigationTitle("Edit Step")
                    .navigationBarTitleDisplayMode(.inline)
            }.background(NM_MAIN)
                .padding()
        }
    }
    
    private func updateStep(_ step: Step)
    {
        step.title = title
        step.body = description
        step.lastUpdated = Date()
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

struct EditStepView_Previews: PreviewProvider {
    static var previews: some View {
        EditStepView(step: Step())
    }
}
