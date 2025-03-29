//  EventView.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var commentsViewModel: CommentsViewModel =
        CommentsViewModel()
    let event: Event

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(String(event.getDate()))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        Text(DatesUtil.getMonthName(from: event.date))
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text(event.title)
                            .font(.title)
                            .fontDesign(.serif)
                            .fontWeight(.bold)

                        if !event.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Descripción")
                                    .font(.headline)
                                Text(event.description)
                                    .font(.system(size: 18))
                                    .foregroundColor(.secondary)
                                    .lineLimit(nil)
                            }
                        }

                        if !commentsViewModel.comments.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Discusión")
                                    .font(.headline)
                                Spacer(minLength: 20)
                                ForEach(commentsViewModel.comments) { comment in
                                    CommentView(comment: comment)
                                        .padding(.vertical, 20)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(
                                                    Color.gray.opacity(0.3)),
                                            alignment: .top
                                        )
                                }
                                Spacer(minLength: 100)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }.padding()
            }

            AddCommentView(text: $commentsViewModel.newCommentText, warning: commentsViewModel.warning) {
                Task {
                    do {
                        try await commentsViewModel.addComment(for: event, user: authViewModel.currentUser!)
                    } catch {
                        print(error)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            commentsViewModel.fetchCommentsForEvent(event)
        }
    }
}

#Preview {
    EventView(event: Event.mocks.first!)
        .environmentObject(AuthViewModel())
}
