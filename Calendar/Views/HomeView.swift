import SwiftUI

struct HomeView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack {
            if isAuthenticated {
                // Show a welcome message if the user is authenticated
                Text("Welcome! You're authenticated.")
                    .padding()
                    .font(.title)
                
                // You can add more functionality here for authenticated users.
                Button(action: {
                    isAuthenticated = false // Log the user out
                }) {
                    Text("Log out")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                }
            } else {
                // Optionally show some message or UI when the user is not authenticated
                Text("Please log in first.")
                    .font(.title)
                    .padding()
            }
        }
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true)) // For preview, assuming the user is authenticated
}
