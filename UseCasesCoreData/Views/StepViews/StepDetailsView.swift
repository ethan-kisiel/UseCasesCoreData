//
//  StepDetailsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/5/22.
//

import SwiftUI

struct StepDetailsView: View {
    let step: Step
    var body: some View {
        HStack
        {
            Text(step.name!)
        }
        Spacer()
        VStack
        {
            Text(step.body!)
        }
    }
}

struct StepDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        //StepDetailsView()
        Text("DetailsPreview")
    }
}
