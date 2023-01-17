//
//  NeumorphicTextBox.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI

struct NeumorphicTextBox: View
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
}

struct NeumorphicTextBox_Previews: PreviewProvider
{
    static var previews: some View
    {
        //NeumorphicTextBox()
        Text("NeumorphicTextBox Preview")
    }
}
