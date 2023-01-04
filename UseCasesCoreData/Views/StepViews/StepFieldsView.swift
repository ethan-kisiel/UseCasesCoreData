//
//  StepFieldsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/1/22.
//

import SwiftUI

struct StepFieldsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State var title: String = EMPTY_STRING

    @State var description: String = EMPTY_STRING

    @FocusState var isFocused: Bool

    private let step: StepEntity?

    private let useCase: UseCaseEntity?

    private let isNewStep: Bool

    init(_ step: StepEntity? = nil, useCase: UseCaseEntity? = nil)
    {
        // if a use case is passed, category is initialized as nil
        // if a category is passed, useCase is initialized as nil

        if let step = step
        {
            // if we are editing an existing step, populate fields:

            self.step = step

            self.useCase = nil

            isNewStep = false

            // initialization happens here, so that the state values
            // which are used as bindings for the text fields
            // can be set to the values of the passed step

            _title = State(wrappedValue: step.wrappedTitle)

            _description = State(wrappedValue: step.desc ?? EMPTY_STRING)
        }
        else
        {
            // if we are creating a new step, pretty much
            // do nothing.

            self.step = nil

            self.useCase = useCase

            isNewStep = true
        }
    }

    var invalidFields: Bool
    {
        title.isEmpty || description.isEmpty
    }

    var body: some View
    {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                withAnimation
                {
                    TextBoxWithFocus("Title", text: $title, isFocused: $isFocused)
                        .padding(8)
                }

                withAnimation
                {
                    TextEditorWithFocus("Description", text: $description, isFocused: $isFocused)
                        .padding(8)
                }

                HStack
                {
                    Button(action:
                    {
                        isNewStep ? addStep() : updateStep(step!)

                        title = EMPTY_STRING
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

                    Button(action:
                        {
                            dismiss()
                        })
                    {
                        Text("Cancel").foregroundColor(.primary)
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }

                    .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                    .padding(8)
                }

                Spacer()

            }.background(NM_MAIN)
            .padding()
        }
        .navigationTitle("\(isNewStep ? "Add" : "Edit") Step")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addStep()
    {
        withAnimation
        {
            let step = StepEntity(context: moc)
            step.id = EntityIdUtil.shared
                .getNewObjectId(StepEntity.self)
            
            step.dateCreated = Date()
            step.lastUpdated = step.dateCreated

            step.title = title
            step.desc = description
       
            step.useCase = useCase
        }
        
        do
        {
            try moc.save()
        }
        catch
        {
            Log.error("Failed to save managed object context.")
        }
    }
    
    private func updateStep(_ step: StepEntity)
    {
        step.title = title
        step.desc = description

        step.lastUpdated = Date()

        do
        {
            try moc.save()
        }
        catch
        {
            Log.error("Failed to save managed object context.")
        }
    }
    
    
}

struct StepFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        StepFieldsView()
    }
}
