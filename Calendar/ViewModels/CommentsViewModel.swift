//
//  CommentsViewModel.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import Combine
import FirebaseFirestore
import FirebaseVertexAI

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var newCommentText = ""
    @Published var warning: String?

    private let vertex = VertexAI.vertexAI()
    private var db = Firestore.firestore()

    private var cancellables = Set<AnyCancellable>()

    init() {
        $newCommentText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                Task {
                    await self.handleCommentChange(text)
                }
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func handleCommentChange(_ text: String) async {
        if text.isEmpty {
            warning = nil
            return
        }
        let model = vertex.generativeModel(
            modelName: "gemini-2.0-flash-lite",
            systemInstruction: .init(
                parts:
                    "You are a bot that prevents hate speech. Your task is that, if you detect hate speech or some text that could be missenterpreted. give a oneline brief warning to the user of the potential damage or offense that their comment might cause. If you see no hate speech at all. just return NULL. Dont talk directly to the user, just warn the consequences or how other would feel about it. Use Spanish language."
            )
        )
        do {
            let response = try await model.generateContent(text)
            if let response = response.text {
                if response.contains("NULL") {
                    warning = nil
                } else {
                    warning = response.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        } catch {
            print("Error generating content: \(error)")
        }
    }

    func fetchCommentsForEvent(_ event: Event) {
        db.collection("events").document(event.id).collection(
            "comments"
        )
        .addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let self = self,
                let documents = querySnapshot?.documents
            else {
                print("No comments found")
                return
            }
            self.handleSnapshot(documents: documents, event: event)
        }
    }

    private func handleSnapshot(
        documents: [QueryDocumentSnapshot], event: Event
    ) {
        var tempComments: [Comment] = []
        var remainingFetches = 0 {
            didSet {
                if remainingFetches == 0 {
                    DispatchQueue.main.async {
                        self.comments = tempComments.sorted {
                            $0.date > $1.date
                        }
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
                    if let comment = self.decodeComment(
                        from: userSnapshot, data: data, event: event,
                        documentID: document.documentID)
                    {
                        tempComments.append(comment)
                    }
                }
            }
        }
    }

    private func decodeComment(
        from userSnapshot: DocumentSnapshot?, data: [String: Any], event: Event,
        documentID: String
    ) -> Comment? {
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

    func addComment(
        text: String? = nil, for event: Event, user: User
    ) async throws -> Comment {
        let userRef = db.collection("users").document(user.id)
        let commentRef = db.collection("events")
            .document(event.id)
            .collection("comments")
            .document()

        let now = Date()
        let commentData: [String: Any] = [
            "userId": userRef,
            "text": text ?? self.newCommentText,
            "date": now,
        ]

        try await commentRef.setData(commentData)

        let userSnapshot = try await userRef.getDocument()

        guard
            let comment = decodeComment(
                from: userSnapshot,
                data: commentData,
                event: event,
                documentID: commentRef.documentID
            )
        else {
            throw NSError(
                domain: "", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to decode comment"
                ])
        }
        
        newCommentText = ""
        warning = nil

        return comment
    }
}
