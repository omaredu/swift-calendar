//
//  Country.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Foundation

struct Country: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let flag: String

    init(id: String = UUID().uuidString, name: String, flag: String) {
        self.id = id
        self.name = name
        self.flag = flag
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        flag = try container.decode(String.self, forKey: .flag)
        id = UUID().uuidString
    }

    static let mocks: [Country] = [
        Country(name: "Mexico", flag: "🇲🇽"),
        Country(name: "United States", flag: "🇺🇸"),
        Country(name: "Canada", flag: "🇨🇦"),
    ]
}
