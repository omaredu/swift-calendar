import SwiftUI
import FirebaseAuth

struct Login: View {
    @State private var password: String = ""
    @Binding var isAuthenticated: Bool
    @Binding var email: String
    @Binding var unregistered: Bool
    @State private var errorMessage: String = "" // For handling errors
    @State private var showAlert: Bool = false // To show alert
    public let cornerRadious: CGFloat = 20
    
    var body: some View {
        NavigationView {
            VStack {
                if isAuthenticated {
                    // Redirect to the main page or home view
                    Text("Welcome! You're authenticated.")
                        .padding()
                        .font(.title)
                } else {
                    Text("Login")
                        .font(.largeTitle)
                        .padding(.bottom, 30)
                        .bold()
                    
                    VStack(alignment: .leading) {
                        Text("Correo electrónico")
                            .padding(.horizontal)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        TextField("Ingresa tu correo electrónico", text: $email)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading) {
                        Text("Contraseña")
                            .padding(.horizontal)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        SecureField("Ingresa tu contraseña", text: $password)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                    }
                    .padding(20)
                    
                    Button(action: {
                        loginUser()
                    }) {
                        Text("Login")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 150)
                            .background(.blue)
                            .cornerRadius(cornerRadious)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        // Redirect to Register or Sign up view
                        unregistered = true
                    }) {
                        Text("¿No tienes cuenta? Regístrate")
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 30)
                    
                    // NavigationLink to Register view
                    NavigationLink(
                        destination: Register(isAuthenticated: $isAuthenticated, email: $email, unregistered: $unregistered),
                        isActive: $unregistered) {
                            EmptyView()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    private func loginUser() {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            showAlert = true
            return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                
                errorMessage = "Error signing in: \(error.localizedDescription)"
                showAlert = true
            } else {
                
                isAuthenticated = true
            }
        }
    }
    
    // Helper function to validate email format
    private func isValidEmail(_ email: String) -> Bool {
        // Basic email format check (can be more advanced)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    Login(isAuthenticated: .constant(false), email: .constant(""), unregistered: .constant(false))
}
