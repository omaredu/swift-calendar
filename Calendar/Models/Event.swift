//
//  Event.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//
import Foundation

struct Event: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let description: String
    let country: Country
}
