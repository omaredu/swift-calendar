//
//  AddCommentView.swift
//  Calendar
//
//  Created by Omar Sánchez on 29/03/25.
//

import SwiftUI

struct AddCommentView: View {
    var body: some View {
        ZStack {
            HStack {
                TextField("Agrega un comentario...", text: .constant(""))
                    .padding(10)
                    .padding(.horizontal, 8)
                    .cornerRadius(20)
                
                Button {
                    // Add comment
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.accentColor))
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    AddCommentView()
}
