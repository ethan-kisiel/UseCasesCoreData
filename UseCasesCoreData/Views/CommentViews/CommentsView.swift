//
//  CommentsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI

struct CommentsView: View
{
    @Binding var isExpanded: Bool
    var isFocused: FocusState<Bool>.Binding
    @State var commentText: String = EMPTY_STRING
    
    var body: some View
    {
        VStack
        {
            Text("List View")
        }
        .onTapGesture
        {
            isFocused.wrappedValue = false
        }
        .background(NM_MAIN)
        .toolbar
        {
            if isExpanded
            {
                if !isFocused.wrappedValue
                {
                    ToolbarItemGroup(placement: .bottomBar)
                    {
                        NeumorphicTextBox("Add a comment",
                                          text: $commentText,
                                          isFocused: isFocused)
                        .frame(height: 50)
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard)
                {
                    HStack
                    {
                        NeumorphicTextBox("Add a comment",
                                          text: $commentText,
                                          isFocused: isFocused)
                        .frame(height: 50)
                        
                        Image(systemName: "paperplane")
                            .foregroundColor(commentText.isEmpty ? .gray : .white)
                    }
                }
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        Text("Comments Preview")
        //CommentsView()
    }
}
