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
        VStack
        {
            Button(action:
                    {
                router.reset()
            })
            {
                Text("Return to Projects").foregroundColor(.primary)
                    .fontWeight(.bold).frame(maxWidth: .infinity)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
            .padding(8)
        }.padding(8)
    }
}

struct ReturnToTopButton_Previews: PreviewProvider {
    static var previews: some View {
        ReturnToTopButton()
    }
}
