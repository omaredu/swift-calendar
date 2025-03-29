//
//  User.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    
    init(id: String = UUID().uuidString, name: String) {
        self.id = id
        self.name = name
    }
    
    static let mocks: [User] = [
        User(name: "Omar"),
        User(name: "Luis"),
        User(name: "Ana"),
    ]
}
