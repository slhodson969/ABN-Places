//
//  ContentView.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel: LocationsViewModel
    
    init(viewModel: LocationsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text("Something went wrong")
                        .font(.headline)
                    
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.load()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                LocationsView(
                    locations: viewModel.locations,
                    didSelectCoordinates: { lat, long in
                        print(lat, long)
                    }
                )
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview("Success") {
    let viewModel = LocationsViewModel(
        loader: PreviewLocationsLoader()
    )
    ContentView(viewModel: viewModel)
}

#Preview("Loading (Delayed)") {
    let viewModel = LocationsViewModel(
        loader: DelayedPreviewLocationsLoader()
    )
    ContentView(viewModel: viewModel)
}

#Preview("Error") {
    let viewModel = LocationsViewModel(
        loader: ErrorPreviewLocationsLoader()
    )
    ContentView(viewModel: viewModel)
}
