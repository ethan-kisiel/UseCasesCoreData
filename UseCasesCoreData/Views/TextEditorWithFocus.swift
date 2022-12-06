//
//  TextEditorWithFocus.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 11/30/22.
//

import SwiftUI
import Neumorphic

struct TextEditorWithFocus: View {
    
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
                    .fontWeight(text.isEmpty ? .light : .bold)
                    .offset(x: text.isEmpty ? 15 : 5, y: text.isEmpty ? -20 : -65)
                    .scaleEffect(text.isEmpty ? 1 : 1, anchor: .leading)
                
                RoundedRectangle(cornerRadius: 5).fill(NM_MAIN)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 5))
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .overlay(
                        ZStack(alignment: .leading)
                        {
                            // offset matches cursor start location
                            // opacity ~matches TextField label opacity
                            
                            Text(title)
                                .foregroundColor(text.isEmpty ? .secondary : .clear)
                                .opacity(0.5)
                                .offset(x: 20, y: -15)
                            TextEditor(text: $text)
                                .scrollContentBackground(.hidden)
                                .background(.clear)
                                .focused(self.isFocused)
                                .padding()
                        }
                    )
                
              
                
            }
            .padding(.top, 15)
        }.animation(.easeInOut(duration: 0.25), value: !text.isEmpty)
    }
}

struct TextEditorWithFocus_Previews: PreviewProvider {
    static var previews: some View {
        //TextEditorWithFocus(String, text: Binding<String>, isFocused: FocusState<Bool>.Binding)
        Text("No Preview")
    }
}

