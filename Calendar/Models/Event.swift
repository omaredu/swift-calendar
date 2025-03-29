//
//  Event.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//
import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: String
    let date: Date
    let title: String
    let description: String
    let country: Country

    init(
        id: String = UUID().uuidString, date: Date, title: String,
        description: String, country: Country
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.country = country
    }
    
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getDate() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    func getMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }

    static let mocks: [Event] = [
        Event(
            date: Date(), title: "Día de la candelaria",
            description:
                "Celebración tradicional del 2 de febrero donde se comparte tamales con amigos y familia, marcando el final de las festividades navideñas. Quien encontró el ‘muñequito’ en la rosca de Reyes, paga los tamales.",
            country: Country.mocks.first!
        )
    ]
}
