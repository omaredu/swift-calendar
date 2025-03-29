//
//  CommentsViewModel.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import FirebaseFirestore

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()

    private var db = Firestore.firestore()

    func fetchCommentsForEvent(_ event: Event) {
        db.collection("events").document("RWuDrMtb31mFC7E55hQV").collection("comments")
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self,
                      let documents = querySnapshot?.documents else {
                    print("No comments found")
                    return
                }
                self.handleSnapshot(documents: documents, event: event)
            }
    }

    private func handleSnapshot(documents: [QueryDocumentSnapshot], event: Event) {
        var tempComments: [Comment] = []
        var remainingFetches = 0 {
            didSet {
                if remainingFetches == 0 {
                    DispatchQueue.main.async {
                        self.comments = tempComments.sorted { $0.date > $1.date }
                    }
                }
            }
        }

        for document in documents {
            let data = document.data()
            if let userRef = data["userId"] as? DocumentReference {
                remainingFetches += 1
                userRef.getDocument { userSnapshot, error in
                    defer { remainingFetches -= 1 }
                    if let comment = self.decodeComment(from: userSnapshot, data: data, event: event, documentID: document.documentID) {
                        tempComments.append(comment)
                    }
                }
            }
        }
    }

    private func decodeComment(from userSnapshot: DocumentSnapshot?, data: [String: Any], event: Event, documentID: String) -> Comment? {
        do {
            guard var userData = userSnapshot?.data() else {
                return nil
            }
            var commentData = data
            commentData["id"] = documentID
            commentData["eventId"] = event.id
            userData["id"] = userSnapshot?.documentID
            commentData["user"] = userData

            let decoder = Firestore.Decoder()
            return try decoder.decode(Comment.self, from: commentData)
        } catch {
            print("Error decoding comment: \(error)")
            return nil
        }
    }
}
