import SwiftUI

struct FormTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var autocapitalization: UITextAutocapitalizationType = .none
    var disableAutocorrection: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .autocapitalization(autocapitalization)
                    .disableAutocorrection(disableAutocorrection)
            }
        }
    }
}

#Preview {
    VStack {
        FormTextField(
            title: "Email",
            placeholder: "Enter your email",
            text: .constant("test@example.com")
        )
        
        FormTextField(
            title: "Password",
            placeholder: "Enter your password",
            text: .constant("password123"),
            isSecure: true
        )
    }
    .padding()
}
