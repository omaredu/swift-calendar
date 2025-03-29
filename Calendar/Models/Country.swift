//
//  Country.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Foundation

struct Country: Identifiable, Codable {
    let id: String
    let name: String
    let flag: String

    init(id: String = UUID().uuidString, name: String, flag: String) {
        self.id = id
        self.name = name
        self.flag = flag
    }
}
