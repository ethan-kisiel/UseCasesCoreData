//
//  TextBoxWithFocus.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/8/22.
//

import SwiftUI
import Neumorphic
//  Moves the text field placeholder value above the text field with animation
//  Usage: TextInputField(title: "First Name", text: $firstName, isFocused: $isFocusd)
//  Takes a focus state binding that can be used in a separate view to change the focus of this element
struct TextBoxWithFocus: View
{
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding

    var title: String

    init(_ title: String, text: Binding<String>, isFocused: FocusState<Bool>.Binding)
    {
        self.title = title
        _text = text
        self.isFocused = isFocused
    }

    var body: some View
    {
        withAnimation
        {
            ZStack(alignment: .leading)
            {
                Text(title + ":")
                    .foregroundColor(text.isEmpty ? .secondary : .secondary)
                    .fontWeight(.bold)
                    .offset(x: text.isEmpty ? 0 : 5, y: text.isEmpty ? 0 : -30)
                    .scaleEffect(text.isEmpty ? 1 : 1, anchor: .leading)


                RoundedRectangle(cornerRadius: 5).fill(NM_MAIN)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 5))
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .overlay(
                    TextField(title, text: $text)
                        .background(.clear)
                            .focused(self.isFocused)
                            .padding()
                    )
            }
            .padding(.top, 15)
        }.animation(.easeInOut(duration: 0.25), value: !text.isEmpty)
    }
}
