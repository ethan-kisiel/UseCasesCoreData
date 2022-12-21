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
    
    let buttonColor: Color
    
    let fontColor: Color
    
    let callBack: () -> Void
    
    
    init(_ text: String, font: Font = .caption,
         buttonColor: Color = NM_MAIN, fontColor: Color = NM_SEC,
         callBack: @escaping () -> Void)
    {
        self.text = text
        self.font = font
        self.buttonColor = buttonColor
        self.fontColor = fontColor
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
                    .foregroundColor(fontColor)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .font(font)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: CGFloat(15)), mainColor: buttonColor)
            .padding(8)
        }.padding(10)
    }
}

struct ReturnToTopButton_Previews: PreviewProvider
{
    static var previews: some View
    {
        NeumorphicButton("test", buttonColor: .blue, fontColor: .white)
        {
            print("Button Pressed")
        }
    }
}
