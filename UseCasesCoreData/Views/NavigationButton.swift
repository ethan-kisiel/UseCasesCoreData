//
//  ReturnToTopButton.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/16/22.
//

import SwiftUI

struct NavigationButton: View
{
    // Takes a variable "text" that will be the button text
    // Also takes a trailing closure "callBack"
    // that will be executed on button press
    // Usage: NavigationButton(text: "Button Text") { <statements> }

    let text: String

    var callBack: () -> Void

    var body: some View
    {
        VStack
        {
            Button(action:
                {
                    callBack()
                })
            {
                Text(text).foregroundColor(.primary)
                    .fontWeight(.bold).frame(maxWidth: .infinity)
                    .font(.subheadline)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)))
            .padding(8)
        }.padding(10)
    }
}

struct ReturnToTopButton_Previews: PreviewProvider
{
    static var previews: some View
    {
        NavigationButton(text: "test")
        {
            print("Button Pressed")
        }
    }
}
