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

    func fetchEvents() {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No events found")
                return
            }

            self.events = documents.compactMap {
                queryDocumentSnapshot -> Event? in
                do {
                    var data = queryDocumentSnapshot.data()
                    data["id"] = queryDocumentSnapshot.documentID
                    
                    let decoder = Firestore.Decoder()
                    return try decoder.decode(Event.self, from: data)
                } catch {
                    print("Error decoding event: \(error)")
                    return nil
                }
            }
        }
    }
    
    func fetchUser(id userId: String) async -> User? {
        let document = db.collection("users").document(userId)
        do {
            let documentSnapshot = try await document.getDocument()
            guard var data = documentSnapshot.data() else {
                return nil
            }
            data["id"] = documentSnapshot.documentID
            
            let decoder = Firestore.Decoder()
            return try decoder.decode(User.self, from: data)
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
}
