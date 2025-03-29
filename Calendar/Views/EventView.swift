//  EventView.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import SwiftUI

struct EventView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var commentsViewModel: CommentsViewModel = CommentsViewModel()
    @ObservedObject var eventsViewModel: EventsViewModel = EventsViewModel()
    let event: Event

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(String(event.getDate()))
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                            Text(DatesUtil.getMonthName(from: event.date))
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 12) {
                            CountryBadge(country: event.country)
                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        Text(event.title)
                            .font(.title)
                            .fontDesign(.serif)
                            .fontWeight(.bold)
                        
                        ImageCarouselView(images: event.images)
                            .padding(.top, 12)
                            .padding(.bottom, 4)
                            .padding(.horizontal, -16) // Negative padding to extend beyond parent padding

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
                                Text("Conversación")
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
                if !commentsViewModel.newCommentText.isEmpty {
                    Task {
                        do {
                            try await commentsViewModel.addComment(for: event, user: authViewModel.currentUser!)
                        } catch {
                            print(error)
                        }
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
    let authViewModel = AuthViewModel()
    let eventsViewModel = EventsViewModel()
    
    return EventView(eventsViewModel: eventsViewModel, event: Event.mocks.first!)
        .environmentObject(authViewModel)
}
