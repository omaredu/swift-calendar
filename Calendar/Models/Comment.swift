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
    
    init(id: String = UUID().uuidString, user: User, text: String, date: Date) {
        self.id = id
        self.user = user
        self.text = text
        self.date = date
    }
}
