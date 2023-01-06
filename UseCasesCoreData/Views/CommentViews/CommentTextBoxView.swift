//
//  CommentTextBoxView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI

struct CommentTextBoxView: View
{
    var isFocused: FocusState<Bool>.Binding
    
    @State var commentText: String = EMPTY_STRING
    
    var body: some View
    {
        TextBoxWithFocus("Add a comment...",
                         text: $commentText,
                         isFocused: isFocused)
    }
}

struct CommentTextBoxView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //CommentTextBoxView()
        Text("Comment Text Box Preview")
    }
}
