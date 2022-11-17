//
//  AddUseCaseView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/17/22.
//

import SwiftUI

struct AddUseCaseView: View
{
    @Environment(\.managedObjectContext) var moc

    let category: Category

    @State var priority: Priority = .medium
    @State var title: String = EMPTY_STRING
    @State var caseId: String = EMPTY_STRING

    @FocusState var isFocused: Bool

    var invalidFields: Bool
    {
        title.isEmpty || caseId.isEmpty
    }

    var body: some View
    {
        VStack(spacing: 5)
        {
            Picker("Priority:", selection: $priority)
            {
                ForEach(Priority.allCases, id: \.self)
                {
                    priority in
                    Text(priority.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(5)

            withAnimation
            {
                TextBoxWithFocus("Use Case", text: $title, isFocused: $isFocused).padding(8)
            }
            withAnimation
            {
                TextBoxWithFocus("ID", text: $caseId, isFocused: $isFocused).padding(8)
            }

            Button(action:
                {
                    addUseCase()

                    title = EMPTY_STRING
                    caseId = EMPTY_STRING
                    priority = .medium
                    isFocused = false
                })
            {
                Text("Add Use Case").foregroundColor(invalidFields ? .secondary : .primary)
                    .fontWeight(.bold).frame(maxWidth: .infinity)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
            .disabled(invalidFields)
            .padding(8)
        }.padding()
    }

    private func addUseCase()
    {
        withAnimation
        {
            let useCase = UseCase(context: moc)
            useCase.id = UUID()
            useCase.name = title
            useCase.priority = priority.rawValue
            useCase.isComplete = false
            useCase.created = Date()
            useCase.lastUpdated = useCase.created
            useCase.parent = category

            do
            {
                try moc.save()
                print("Successfully saved use case")
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }
}

struct AddUseCaseView_Previews: PreviewProvider
{
    static var previews: some View
    {
        AddUseCaseView(category: Category())
    }
}
