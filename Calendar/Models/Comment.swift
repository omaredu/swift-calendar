//
//  Comment.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    let user: User
    let text: String
    let date: Date
    let eventId: String

    init(
        id: String = UUID().uuidString,
        user: User,
        text: String,
        date: Date,
        eventId: String
    ) {
        self.id = id
        self.user = user
        self.text = text
        self.date = date
        self.eventId = eventId
    }

    static let mocks: [Comment] = [
        Comment(
            user: User.mocks.first!,
            text: "¡Qué buena idea!",
            date: Date(),
            eventId: Event.mocks.first!.id
        ),
        Comment(
            user: User.mocks.last!,
            text: "¡Me encanta!",
            date: Date(),
            eventId: Event.mocks.first!.id
        ),
    ]
}
