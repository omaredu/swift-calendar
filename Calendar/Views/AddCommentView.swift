//
//  AddCommentView.swift
//  Calendar
//
//  Created by Omar Sánchez on 29/03/25.
//

import SwiftUI

struct AddCommentView: View {
    @Binding var text: String
    var warning: String? = nil
    var action: () -> Void = {}

    var body: some View {
        ZStack {

            VStack(spacing: 0) {
                if let warning = warning {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.secondary)
                        Text(warning)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding()
                        .background(.ultraThickMaterial)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(
                                    Color.gray.opacity(0.1)),
                            alignment: .bottom
                        )
                }

                HStack {
                    TextField("Agrega un comentario...", text: $text)
                        .padding(10)
                        .padding(.horizontal, 8)
                        .cornerRadius(20)

                    Button {
                        action()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.accentColor))
                    }
                }
                .padding(8)
            }

            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
}

#Preview("Normal", traits: .sizeThatFitsLayout) {
    AddCommentView(text: .constant(""))
}

#Preview("Warning", traits: .sizeThatFitsLayout) {
    AddCommentView(text: .constant(""), warning: "El comentario no puede estar vacío")
}
