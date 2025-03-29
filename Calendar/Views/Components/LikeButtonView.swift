//
//  LikeButtonView.swift
//  Calendar
//
//  Created by Omar Sánchez on 29/03/25.
//

import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLiked.toggle()
                action()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .frame(width: 44, height: 44)
                
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isLiked ? .red : .gray)
                    .scaleEffect(isLiked ? 1.1 : 1.0)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style for scaling effect
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 50) {
            LikeButtonView(isLiked: .constant(false))
            LikeButtonView(isLiked: .constant(true))
        }
    }
    .padding()
}