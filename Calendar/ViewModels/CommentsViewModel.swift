import FirebaseFirestore
import Combine

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchComments(for eventId: String) {
        isLoading = true
        db.collection("events")
            .document(eventId)
            .collection("comments")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.error = error
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.comments = []
                    return
                }
                
                self.comments = documents.compactMap { document in
                    do {
                        var comment = try document.data(as: Comment.self)
                        
                        if let userData = document.data()["user"] as? [String: Any] {
                            let user = try Firestore.Decoder().decode(User.self, from: userData)
                            return Comment(
                                id: document.documentID,
                                user: user,
                                text: comment.text,
                                date: comment.date
                            )
                        }
                        return comment
                    } catch {
                        self.error = error
                        return nil
                    }
                }
            }
    }
    
    func addComment(_ text: String, for eventId: String, user: User) {
        isLoading = true
        let newComment = Comment(
            user: user,
            text: text,
            date: Date()
        )
        
        do {
            let commentData = try Firestore.Encoder().encode(newComment)
            db.collection("events")
                .document(eventId)
                .collection("comments")
                .addDocument(data: commentData) { [weak self] error in
                    self?.isLoading = false
                    if let error = error {
                        self?.error = error
                    }
                }
        } catch {
            self.error = error
            isLoading = false
        }
    }
}
