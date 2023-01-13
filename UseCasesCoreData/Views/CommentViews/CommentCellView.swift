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
        VStack
        {
            // display username
            HStack
            {
                Text("\(comment.wrappedCreatedBy)")
            }
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
