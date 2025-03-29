//
//  ContentView.swift
//  Calendar
//
//  Created by Omar Sánchez on 28/03/25.
//

import SwiftUI
import SwiftData
import FirebaseVertexAI

struct ContentView: View {
    @ObservedObject var eventsViewModel = EventsViewModel()
    @Environment(\.modelContext) private var modelContext
    private let vertex = VertexAI.vertexAI()
    @State private var generatedText = ""

    var body: some View {
        Button("Fetch Events") {
            fetchEvents()
        }
        Button("Generate") {
            Task {
                await generate()
            }
        }
        Text(generatedText)
        ForEach(eventsViewModel.events) { event in
            Text(event.title)
        }
    }
    
    private func fetchEvents() {
        eventsViewModel.fetch()
    }
    
    private func generate() async {
        let model = vertex.generativeModel(modelName: "gemini-2.0-flash")
        do {
            let response = try await model.generateContent("Say something nice")
            generatedText = response.text ?? "No text generated"
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}
