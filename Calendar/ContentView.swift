import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var eventsViewModel = EventsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.currentUser != nil {
                    if let todayEvent = eventsViewModel.getTodayEvents().first {
                        EventView(event: todayEvent)
                            .navigationBarItems(trailing: Button(action: {
                                authViewModel.signOut()
                            }) {
                                Text("Salir")
                                    .foregroundColor(.red)
                            })
                    } else {
                        VStack(spacing: 10) {
                            Text("Parece que hoy no hay eventos")
                                .font(.title)
                                .fontWeight(.bold)
                                
                            Text("Vuelve mañana para ver que evento especial tememos para ti")
                                .foregroundColor(.secondary)
                                .font(.body)
                        }
                        .padding()
                        .navigationBarItems(trailing: Button(action: {
                            authViewModel.signOut()
                        }) {
                            Text("Salir")
                                .foregroundColor(.red)
                        })
                    }
                } else {
                    LoginView()
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            eventsViewModel.fetchEvents()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
