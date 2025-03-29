//
//  ImageCarouselView.swift
//  Calendar
//
//  Created by Omar Sánchez on 29/03/25.
//

import SwiftUI

struct ImageCarouselView: View {
    let images: [String]
    private let cardSize: CGFloat = 180 // Square size for cards
    private let spacing: CGFloat = 12
    
    var body: some View {
        if images.isEmpty {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: cardSize, height: cardSize)
                .cornerRadius(16)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
        } else {
            // Using fixed height container to prevent layout overflow
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(images.indices, id: \.self) { index in
                        imageCard(for: images[index])
                            .frame(width: cardSize, height: cardSize)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: cardSize)
        }
    }
    
    @ViewBuilder
    private func imageCard(for imageURL: String) -> some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                    ProgressView()
                }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Fill to make images square
                    .frame(width: cardSize, height: cardSize)
                    .clipped() // Clip to ensure square shape
                    .cornerRadius(16)
            case .failure:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ImageCarouselView(images: [
        "https://images.unsplash.com/photo-1577219491135-ce391730fb2c",
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
        "https://images.unsplash.com/photo-1557844352-761f2565b576"
    ])
}