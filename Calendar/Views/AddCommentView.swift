import SwiftUI

struct AddCommentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommentsViewModel
    @State private var commentText = ""
    let eventId: String
    let currentUser: User
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Escribe tu comentario", text: $commentText, axis: .vertical)
                        .lineLimit(5...)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Nuevo Comentario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enviar") {
                        viewModel.addComment(commentText, for: eventId, user: currentUser)
                        dismiss()
                    }
                    .disabled(commentText.isEmpty || viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.error = nil
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Error desconocido")
            }
        }
    }
}
