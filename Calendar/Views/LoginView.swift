import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToRegister: Bool = false
    @State private var navigateToHome: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Inicia sesión")
                                .font(.largeTitle)
                                .fontDesign(.serif)
                                .fontWeight(.bold)

                            Text("Continúa tu experiencia en Calendar")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.headline)

                            TextField(
                                "Ingresa tu correo electrónico", text: $email
                            )
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.headline)

                            SecureField(
                                "Ingresa tu contraseña", text: $password
                            )
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        }

                        // Login button
                        Button {
                            authViewModel.login(
                                email: email, password: password
                            ) { success in
                                if success {
                                    navigateToHome = true
                                }
                            }
                        } label: {
                            Text("Iniciar sesión")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(16)
                        }
                        .padding(.top, 16)

                        // Register link
                        Button {
                            navigateToRegister = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("¿No tienes cuenta? Regístrate")
                                    .foregroundColor(.accentColor)
                                Spacer()
                            }
                        }
                        .padding(.top, 24)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)  // Extra space at bottom for scrolling
                }

                // Navigation links
                NavigationLink(
                    destination: RegisterView(), isActive: $navigateToRegister
                ) {
                    EmptyView()
                }

            }
            .alert(
                isPresented: Binding<Bool>(
                    get: { authViewModel.errorMessage != nil },
                    set: { newValue in
                        if !newValue {
                            authViewModel.errorMessage = nil
                        }
                    })
            ) {
                Alert(
                    title: Text("Error"),
                    message: Text(authViewModel.errorMessage!),
                    dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
