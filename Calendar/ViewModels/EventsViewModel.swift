//
//  EventsViewModel.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import FirebaseFirestore

class EventsViewModel: ObservableObject {
    @Published var events = [Event]()
    
    private var db = Firestore.firestore()
    
    func getTodayEvents() -> [Event] {
        return getDateEvents(Date())
    }
    
    func getDateEvents(_ date: Date) -> [Event] {
        return events.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: date)
        }
    }
        
    func fetch() {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No events found")
                return
            }

            self.events = documents.map { queryDocumentSnapshot -> Event in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                
                let countryData = data["country"] as? [String: String] ?? [:]
                let country = Country(
                    name: countryData["name"] ?? "",
                    flag: countryData["flag"] ?? "")
                
                return Event(
                    date: date.dateValue(),
                    title: title,
                    description: description,
                    country: country
                )
            }
        }
    }
}
