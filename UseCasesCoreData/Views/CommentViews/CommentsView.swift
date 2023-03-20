//
//  CommentsView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI
import CoreData

struct CommentsView: View
{
    @Environment(\.managedObjectContext) var moc
    
    @Binding var isExpanded: Bool
    
    @State var commentText: String = EMPTY_STRING
    
    let parentObject: BaseModelEntity
    
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View
    {
        VStack
        {
            CommentsListView(parentObject: parentObject)
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
                            .onTapGesture
                            {
                                if !commentText.isEmpty
                                {
                                    if saveComment()
                                    {
                                        commentText = EMPTY_STRING
                                        isFocused.wrappedValue = false
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    private func saveComment() -> Bool
    {
        let comment = CommentEntity(context: moc)
        
        comment.createdBy = UserInfoUtil.shared.getUserFullName()
        comment.commentText = commentText
        
        parentObject.addToComments(comment)
        
        do
        {
            try moc.save()
            return true
        }
        catch
        {
            Log.error("Failed to save new comment.")
        }
        
        return false
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
