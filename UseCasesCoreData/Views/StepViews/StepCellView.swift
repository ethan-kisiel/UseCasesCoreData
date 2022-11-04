//
//  StepCellView.swift
//  UseCasesLocalRealm
//
//  Created by Ethan Kisiel on 7/11/22.
//

import SwiftUI

struct StepCellView: View
{
    var step: Step
    @State var trashIsEnabled: Bool = false
    var body: some View
    {
        HStack(alignment: .center)
        {
            // Constants.TRASH_ICON: String
            Image(systemName: TRASH_ICON).foregroundColor(trashIsEnabled ? .red : .gray)
                .disabled(trashIsEnabled)
                .onLongPressGesture(minimumDuration: 0.8)
                {
                    trashIsEnabled.toggle()
                }
            /*
                .onTapGesture
                {
                    if trashIsEnabled
                    {
                        StepManager.shared.deleteStep(step: step)
                    }
                }
    
            Text(step.text)
            Spacer()
            let stepId = step.stepId.shorten(by: 3)

            Text(stepId)
             */
        }
    }
}

struct StepCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //let step = Step(text: "")
        //StepCellView(step: step)
        Text("Preview")
    }
}
