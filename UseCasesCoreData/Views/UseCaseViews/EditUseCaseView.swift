//
//  EditUseCaseView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/9/22.
//

import SwiftUI

struct EditUseCaseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    let useCase: UseCase
    @State var priority: Priority
    @State var title: String
    @State var caseId: String
    
    @FocusState var isFocused: Bool
    
    init(useCase: UseCase)
    {
        self.useCase = useCase
        _priority = State(wrappedValue: Priority(rawValue: useCase.wrappedPriority) ?? .medium)
        _title = State(wrappedValue: useCase.wrappedTitle)
        _caseId = State(wrappedValue: useCase.wrappedId)
    }
    
    var invalidFields: Bool
    {
        title.isEmpty || caseId.isEmpty
    }
    
    var body: some View {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                Text(useCase.wrappedTitle)
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
                    updateUseCase(useCase)
                    
                    title = EMPTY_STRING
                    caseId = EMPTY_STRING
                    priority = .medium
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
                
                Spacer()
                    .navigationTitle("Edit Use Case")
                    .navigationBarTitleDisplayMode(.inline)
            }.background(NM_MAIN)
                .padding()
            
        }
    
    }
    
    private func updateUseCase(_ useCase: UseCase)
    {
        useCase.title = title
        useCase.priority = priority.rawValue
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

struct EditUseCaseView_Previews: PreviewProvider {
    static var previews: some View {
        EditUseCaseView(useCase: UseCase())
    }
}
