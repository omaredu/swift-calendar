import Firebase
import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    init() {
        checkUserSession()
    }

    func login(
        email: String, password: String, completion: @escaping (Bool) -> Void
    ) {
        guard isValidEmail(email) else {
            self.errorMessage = "Invalid email format."
            completion(false)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.errorMessage =
                    "Error signing in: \(error.localizedDescription)"
                completion(false)
            } else {
                if let userId = result?.user.uid {
                    self.fetchUserData(userId: userId)
                }
                completion(true)
            }
        }
    }

    func register(
        name: String, email: String, password: String, confirmPassword: String
    ) async -> User? {
        guard isValidEmail(email) else {
            self.errorMessage = "Invalid email format."
            return nil
        }

        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match."
            return nil
        }

        guard !name.isEmpty else {
            self.errorMessage = "Name is required."
            return nil
        }

        guard password.count >= 6 else {
            self.errorMessage = "Password must be at least 6 characters."
            return nil
        }

        do {
            let result = try await Auth.auth().createUser(
                withEmail: email, password: password)
            let userId = result.user.uid
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userId)

            try await userRef.setData(["id": userId, "name": name])

            // Create and store user object
            let newUser = User(id: userId, name: name)
            self.currentUser = newUser
            return newUser
        } catch {
            self.errorMessage =
                "Error creating user: \(error.localizedDescription)"
            return nil
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
        } catch let error {
            self.errorMessage =
                "Error signing out: \(error.localizedDescription)"
        }
    }

    private func fetchUserData(userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument {
            [weak self] document, error in
            guard let self = self else { return }

            if let document = document, document.exists {
                if let userData = document.data() {
                    self.currentUser = User(
                        id: userId,
                        name: userData["name"] as? String ?? "User"
                    )
                }
            } else if let error = error {
                self.errorMessage =
                    "Error fetching user data: \(error.localizedDescription)"
            }
        }
    }

    private func checkUserSession() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserData(userId: currentUser.uid)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
