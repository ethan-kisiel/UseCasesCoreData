//
//  ReturnToTopButton.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/16/22.
//

import SwiftUI

struct NeumorphicButton: View
{
    // Takes a variable "text" that will be the button text
    // Also takes a trailing closure "callBack"
    // that will be executed on button press
    // Usage: NavigationButton(text: "Button Text") { <statements> }
    
    let text: String
    
    let font: Font
    
    let foregroundColor: Color
    
    let callBack: () -> Void
    
    init(_ text: String, font: Font = .caption, color: Color = .primary, callBack: @escaping () -> Void)
    {
        self.text = text
        self.font = font
        self.foregroundColor = color
        self.callBack = callBack
    }
    var body: some View
    {
        VStack
        {
            Button(action:
                {
                    callBack()
                })
            {
                Text(text)
                    .foregroundColor(foregroundColor)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .font(font)
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
        NeumorphicButton("test", color: .blue)
        {
            print("Button Pressed")
        }
    }
}
