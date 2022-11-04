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
    @State var useCase: UseCase
    @State var showAddFields: Bool = false
    @FocusState var isFocused: Bool

    @State var text: String = EMPTY_STRING
    @State var stepId: String = EMPTY_STRING

    var body: some View
    {
        /*
        HStack(alignment: .top)
        {
            Text("ID: \(useCase.caseId)")
                .fontWeight(.semibold)
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
                    TextInputFieldWithFocus("Step", text: $text, isFocused: $isFocused).padding(8)
                }
                withAnimation
                {
                    TextInputFieldWithFocus("ID", text: $stepId, isFocused: $isFocused).padding(8)
                }

                Button(action:
                    {
                        let step = Step(text: text)
                        step.stepId = stepId
                        //StepManager.shared.addStep(useCase: useCase, step: step)
                        text = EMPTY_STRING
                        stepId = EMPTY_STRING
                        isFocused = false
                    })
                {
                    Text("Add Step").foregroundColor(text.isEmpty ? .secondary : .primary)
                        .fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
                .disabled(text.isEmpty)
            }.padding()
        }
        Spacer()
        StepListView(useCase: useCase)
        //Spacer().navigationTitle("(Use Case) " + useCase.caseId.shorten(by: DISP_SHORT))
            .navigationBarTitleDisplayMode(.inline)*/
        
        Text("UseCaseDetailsView")
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
