//
//  MonthUtil.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//
import Foundation

struct DatesUtil {
    static let months: [Int: String] = [
        1: "Enero",
        2: "Febrero",
        3: "Marzo",
        4: "Abril",
        5: "Mayo",
        6: "Junio",
        7: "Julio",
        8: "Agosto",
        9: "Septiembre",
        10: "Octubre",
        11: "Noviembre",
        12: "Diciembre",
    ]

    static func getMonthName(from month: Int) -> String {
        return months[month] ?? "Mes inválido"
    }

    static func getMonthName(from date: Date) -> String {
        let month = Calendar.current.component(.month, from: date)
        return getMonthName(from: month)
    }

    static func getRelativeTime(from date: Date) -> String {
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(date))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        switch secondsAgo {
        case 0..<60:
            return "Justo ahora"
        case 60..<hour:
            let minutes = secondsAgo / minute
            return "Hace \(minutes) minuto\(minutes > 1 ? "s" : "")"
        case hour..<day:
            let hours = secondsAgo / hour
            return "Hace \(hours) hora\(hours > 1 ? "s" : "")"
        case day..<week:
            let days = secondsAgo / day
            return "Hace \(days) día\(days > 1 ? "s" : "")"
        default:
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es_MX")
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}
