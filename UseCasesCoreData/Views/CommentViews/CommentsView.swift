//
//  CommentsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI

struct CommentsView: View
{
    @FocusState var isFocused: Bool
    @State var commentText: String = EMPTY_STRING
    
    var body: some View
    {
        VStack
        {
            // List of comments for the given item
            
            // Toolbar keyboard item text box
        }
        /*.toolbar
        {
            ToolbarItemGroup(placement: isFocused ? .keyboard : .bottomBar)
            {
                CommentTextBoxView(isFocused: $isFocused)
            }
        }*/
    }
}

struct CommentsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CommentsView()
    }
}
