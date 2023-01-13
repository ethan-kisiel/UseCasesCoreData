//
//  CommentCellView.swift
//  UseCasesCoreData
//
//  Created by Ethan Kisiel on 1/6/23.
//

import SwiftUI

struct CommentCellView: View
{
    let comment: CommentEntity
    var body: some View
    {
        VStack(alignment: .leading)
        {
            // display username
            HStack
            {
                Text(comment.wrappedCreatedBy)
                    .font(.caption)
            }
            
            Text(comment.wrappedText)
        }
    }
}

struct CommentCellView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CommentCellView(comment: CommentEntity())
    }
}
