//
//  ReturnToTopButton.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/16/22.
//

import SwiftUI

struct ReturnToTopButton: View {
    @EnvironmentObject var router: Router
    @State var displayAlert: Bool = false
    
    var body: some View
    {
        Image(systemName: "arrow.counterclockwise")
            .onTapGesture
            {
                displayAlert = true
            }
            .alert(isPresented: $displayAlert, content:
            {
                Alert(
                    title: Text("Do you wish to return to the projects view?"),
                    primaryButton: .default(Text("Yes"), action:
                    {
                        router.reset()
                    }),
                    secondaryButton: .cancel()
                )
            })
    }
}

struct ReturnToTopButton_Previews: PreviewProvider {
    static var previews: some View {
        ReturnToTopButton()
    }
}
