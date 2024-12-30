//
//  EditView.swift
//  BucketList
//
//  Created by Satinder Singh on 29/12/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    var onDelete: (Location) -> Void
    @State private var viewModel: ViewModel
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .laoded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
                
                Button("Delete", role: .destructive) {
                    onDelete(viewModel.location)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
        self.onSave = onSave
        self.onDelete = onDelete
        
        _viewModel = State(initialValue: ViewModel(location: location, name: location.name, description: location.description))
    }
}

#Preview {
    EditView(location: Location(id: UUID(), name: "Test", description: "This is some description", latitude: -50, longitude: 4)) {_ in} onDelete: {_ in}
}
