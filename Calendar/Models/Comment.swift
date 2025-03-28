//
//  Comment.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()
    let user: User
    let text: String
    let date: Date
}
