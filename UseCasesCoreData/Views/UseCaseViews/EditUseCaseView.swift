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
    
    let useCase: UseCaseEntity
    @State var title: String
    
    @FocusState var isFocused: Bool
    
    init(useCase: UseCaseEntity)
    {
        self.useCase = useCase
        //_priority = State(wrappedValue: Priority(rawValue: useCase.wrappedPriority) ?? .medium)
        _title = State(wrappedValue: useCase.wrappedTitle)
    }
    
    var invalidFields: Bool
    {
        title.isEmpty
    }
    
    var body: some View {
        ZStack
        {
            NM_MAIN.edgesIgnoringSafeArea(.all)
            VStack
            {
                
                withAnimation
                {
                    TextBoxWithFocus("Use Case", text: $title, isFocused: $isFocused).padding(8)
                }
                
                Button(action:
                        {
                    updateUseCase(useCase)
                    
                    title = EMPTY_STRING
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
    
    private func updateUseCase(_ useCase: UseCaseEntity)
    {
        useCase.title = title
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
        EditUseCaseView(useCase: UseCaseEntity())
    }
}
