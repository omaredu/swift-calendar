import FirebaseAuth
import SwiftUI

struct RegisterView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToLogin: Bool = false
    @State private var navigateToHome: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Crea tu cuenta")
                            .font(.largeTitle)
                            .fontDesign(.serif)
                            .fontWeight(.bold)

                        Text("Únete a la comunidad de Calendar")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nombre")
                            .font(.headline)

                        TextField("Ingresa tu nombre", text: $name)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .autocapitalization(.words)
                    }

                    // Email field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correo electrónico")
                            .font(.headline)

                        TextField("Ingresa tu correo electrónico", text: $email)
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

                        SecureField("Ingresa tu contraseña", text: $password)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }

                    // Confirm Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirmar Contraseña")
                            .font(.headline)

                        SecureField(
                            "Confirma tu contraseña", text: $confirmPassword
                        )
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    }

                    // Register button
                    Button {
                        Task {
                            guard let user = await authViewModel.register(
                                name: name,
                                email: email, password: password,
                                confirmPassword: confirmPassword
                            ) else { return }
                            
                            navigateToHome = true
                        }
                        
                    } label: {
                        Text("Registrarse")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(16)
                    }
                    .padding(.top, 16)

                    // Login link
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("¿Ya tienes cuenta? Inicia sesión")
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
        }
        .alert(
            isPresented: Binding<Bool>(
                get: { authViewModel.errorMessage != nil },
                set: { newValue in
                    if !newValue {
                        authViewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Alert(
                title: Text("Error"),
                message: Text(authViewModel.errorMessage!),
                dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    RegisterView()
}
