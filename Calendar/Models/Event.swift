//
//  Event.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//
import Foundation

struct Event: Identifiable, Codable {
    let id: String
    let date: Date
    let title: String
    let description: String
    let country: Country
    
    init(id: String = UUID().uuidString, date: Date, title: String, description: String, country: Country) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.country = country
    }
}
