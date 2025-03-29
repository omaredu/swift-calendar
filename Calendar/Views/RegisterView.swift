import FirebaseAuth
import SwiftUI
// Import our custom components

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToLogin: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Spacer(minLength: 100)

                        VStack(alignment: .leading) {
                            Text("Crea tu cuenta")
                                .font(.largeTitle)
                                .fontDesign(.serif)

                            Text("Únete a la comunidad de Wherevent")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer(minLength: 60)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            FormTextField(
                                title: "Nombre",
                                placeholder: "Ingresa tu nombre",
                                text: $name,
                                autocapitalization: .words
                            )
                            
                            FormTextField(
                                title: "Correo electrónico",
                                placeholder: "Ingresa tu correo electrónico",
                                text: $email
                            )
                            
                            FormTextField(
                                title: "Contraseña",
                                placeholder: "Ingresa tu contraseña",
                                text: $password,
                                isSecure: true
                            )
                            
                            FormTextField(
                                title: "Confirmar Contraseña",
                                placeholder: "Confirma tu contraseña",
                                text: $confirmPassword,
                                isSecure: true
                            )
                        }
                        
                        Spacer(minLength: 200)
                    }
                    .padding()
                }

                VStack(spacing: 24) {
                    PrimaryButton(
                        title: "Registrarse",
                        action: {
                            Task {
                                let success = await authViewModel.register(
                                    name: name,
                                    email: email, password: password,
                                    confirmPassword: confirmPassword
                                ) != nil
                                
                                if success {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    )

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("¿Ya tienes cuenta? Inicia sesión")
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(
                            Color.gray.opacity(0.2)),
                    alignment: .top
                )
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
    RegisterView()
        .environmentObject(AuthViewModel())
}
