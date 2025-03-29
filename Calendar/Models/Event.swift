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
    let images: [String]
    let likes: Int
    let title: String
    let description: String
    let country: Country

    init(
        id: String = UUID().uuidString, date: Date, title: String,
        description: String, country: Country, images: [String] = [], likes: Int = 0
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.country = country
        self.images = images
        self.likes = likes
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
                "Celebración tradicional del 2 de febrero donde se comparte tamales con amigos y familia, marcando el final de las festividades navideñas. Quien encontró el 'muñequito' en la rosca de Reyes, paga los tamales.",
            country: Country.mocks.first!,
            images: [
                "https://images.unsplash.com/photo-1577219491135-ce391730fb2c",
                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
                "https://images.unsplash.com/photo-1557844352-761f2565b576",
                "https://images.unsplash.com/photo-1562059390-a761a084768e"
            ],
            likes: 42
        )
    ]
}
