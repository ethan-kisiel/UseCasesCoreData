//
//  CommentsListView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/10/23.
//

import SwiftUI

struct CommentsListView: View
{
    let parentObject: BaseModelEntity
    
    private var filteredComments: [CommentEntity]
    {
        return parentObject.wrappedComments
    }
    
    var body: some View
    {
        VStack
        {
            
            if filteredComments.isEmpty
            {
                Text("No comments to display.")
            }
            else
            {
                List
                {
                    ForEach(filteredComments, id: \.id)
                    {
                        comment in
                        CommentCellView(comment: comment)
                    }
                    .listRowBackground(NM_MAIN)
                }
                .listStyle(.plain)
                .padding()
                .scrollContentBackground(.hidden)
            }
        }
        .background(NM_MAIN)
    }
}

struct CommentsListView_Previews: PreviewProvider
{
    static var previews: some View
    {
        //CommentsListView()
        Text("CommentsListView")
    }
}
