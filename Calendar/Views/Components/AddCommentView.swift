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
                    TextField("Conversa con el mundo...", text: $text)
                        .padding(10)
                        .padding(.horizontal, 8)
                        .cornerRadius(20)

                    let isTextEmpty = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    
                    Button {
                        action()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(isTextEmpty ? Color.gray : Color.accentColor))
                            .opacity(isTextEmpty ? 0.6 : 1.0)
                    }
                    .disabled(isTextEmpty)
                    .animation(.easeInOut(duration: 0.2), value: isTextEmpty)
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
