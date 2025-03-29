import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var userEmail: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var unregistered: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if isAuthenticated {
                    HomeView(isAuthenticated: $isAuthenticated)
                } else {
                    Login(isAuthenticated: $isAuthenticated, email: $userEmail, unregistered: $unregistered)
                }
            }
            .onAppear {
                checkAuthentication()
            }
        }
    }
    
    func checkAuthentication() {
        if let currentUser = Auth.auth().currentUser {
            isAuthenticated = true
            userEmail = currentUser.email ?? ""
        } else {
            isAuthenticated = false
        }
    }
}

#Preview {
    ContentView()
}
