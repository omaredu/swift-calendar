import SwiftUI
import FirebaseAuth

struct Register: View {
    
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @Binding var isAuthenticated: Bool
    @Binding var email: String
    @Binding var unregistered: Bool
    public let cornerRadious: CGFloat = 20
    @State private var errorMessage: String = "" // For handling errors
    @State private var showAlert: Bool = false // To show alert
    
    var body: some View {
        NavigationView {
            VStack {
                if isAuthenticated {
                    // Redirect to Home view (when user is authenticated)
                    NavigationLink(destination: HomeView(isAuthenticated: $isAuthenticated)) {
                        Text("Welcome! You're authenticated.")
                            .padding()
                            .font(.title)
                    }
                } else {
                    Text("Register")
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
                    
                    VStack(alignment: .leading) {
                        Text("Confirmar Contraseña")
                            .padding(.horizontal)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        SecureField("Confirma tu contraseña", text: $confirmPassword)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 5, y: 5)
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        // Handle registration logic
                        registerUser()
                    }) {
                        Text("Registrarse")
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
                        // Redirect to Login view
                        unregistered = false
                    }) {
                        Text("¿Ya tienes cuenta? Inicia sesión")
                    }
                    .padding(.top, 30)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Register the user with Firebase
    private func registerUser() {
        // Validation checks for email and password
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            showAlert = true
            return
        }

        // Firebase registration logic
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                // Handle error (e.g., show an alert)
                errorMessage = "Error creating user: \(error.localizedDescription)"
                showAlert = true
            } else {
                // Successful registration
                isAuthenticated = true
                                
                unregistered = false
                
            }
        }
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        // Basic email format check (can be more advanced)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    Register(
        isAuthenticated: .constant(false),
        email: .constant(""),
        unregistered: .constant(true)
    )
}
