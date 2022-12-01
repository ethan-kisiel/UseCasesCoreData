//
//  UseCaseFieldsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 12/1/22.
//

import SwiftUI

struct UseCaseFieldsView: View
{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State var title: String = EMPTY_STRING

    @State var description: String = EMPTY_STRING

    @FocusState var isFocused: Bool

    private let useCase: UseCaseEntity?

    private let category: CategoryEntity?

    private let isNewUseCase: Bool

    init(_ useCase: UseCaseEntity? = nil, category: CategoryEntity? = nil)
    {
        // if a use case is passed, category is initialized as nil
        // if a category is passed, useCase is initialized as nil

        if let useCase = useCase
        {
            // if we are editing an existing use case, populate fields:

            self.useCase = useCase

            self.category = nil

            isNewUseCase = false

            // initialization happens here, so that the state values
            // which are used as bindings for the text fields
            // can be set to the values of the passed project

            _title = State(wrappedValue: useCase.wrappedTitle)

            _description = State(wrappedValue: useCase.desc ?? EMPTY_STRING)
        }
        else
        {
            // if we are creating a new use case, pretty much
            // do nothing.

            self.useCase = nil

            self.category = category

            isNewUseCase = true
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
                        isNewUseCase ? addUseCase() : updateUseCase(useCase!)

                        title = EMPTY_STRING
                        description = EMPTY_STRING

                        isFocused = false
                        dismiss()
                    })
                    {
                        Text("Save Use Case").foregroundColor(invalidFields ? .secondary : .primary)
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
        .navigationTitle("\(isNewUseCase ? "Add" : "Edit") Use Case")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addUseCase()
    {
        withAnimation
        {
            let useCase = UseCaseEntity(context: moc)

            useCase.id = EntityIdUtil.shared
                .getNewObjectId(UseCaseEntity.self)

            useCase.dateCreated = Date()
            useCase.lastUpdated = useCase.dateCreated

            useCase.title = title
            useCase.desc = description

            useCase.category = category

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
    
    private func updateUseCase(_ useCase: UseCaseEntity)
    {
        useCase.title = title
        useCase.desc = description

        useCase.lastUpdated = Date()
        
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

struct UseCaseFieldsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        UseCaseFieldsView()
    }
}
