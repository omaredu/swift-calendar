import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToRegister: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Spacer(minLength: 100)

                        VStack(alignment: .leading) {

                            Text("Inicia sesión")
                                .font(.largeTitle)
                                .fontDesign(.serif)

                            Text("Continúa tu experiencia en Today's Space")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Spacer(minLength: 100)

                        VStack(alignment: .leading, spacing: 24) {
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
                        }
                        
                        Spacer(minLength: 200)
                    }
                    .padding()
                }

                VStack(spacing: 24) {
                    PrimaryButton(
                        title: "Iniciar sesión",
                        action: {
                            authViewModel.login(
                                email: email, password: password
                            ) { _ in }
                        }
                    )

                    Button {
                        navigateToRegister = true
                    } label: {
                        Text("¿No tienes cuenta? Regístrate")
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(
                            Color.gray.opacity(0.3)),
                    alignment: .top
                )
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
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
        .environmentObject(AuthViewModel())
}
 
