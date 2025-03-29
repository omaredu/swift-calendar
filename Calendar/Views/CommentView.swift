//
//  CommentView.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.user.name)
                    .font(.headline)
                    
                Spacer()
                Text(DatesUtil.getRelativeTime(from: comment.date))
                    .foregroundStyle(.secondary)
            }
            
            Text(comment.text)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CommentView(comment: Comment.mocks.first!)
}
