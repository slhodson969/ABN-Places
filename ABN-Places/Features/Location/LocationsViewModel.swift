//
//  LocationsViewModel.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

import Foundation

@MainActor
@Observable
final class LocationsViewModel {
    var locations: [Location] = []
    var isLoading = false
    var errorMessage: String?
    
    private let loader: LocationsLoader
    
    init(loader: LocationsLoader) {
        self.loader = loader
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            locations = try await loader.load()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
