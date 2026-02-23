//
//  ABN_PlacesApp.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import SwiftUI

@main
struct ABN_PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: makeViewModel()
            )
        }
    }
    
    private func makeViewModel() -> LocationsViewModel {
        let baseURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main")!
        let url = LocationsEndpoint.getAll.url(baseURL: baseURL)
        let client = URLSessionHTTPClient(session: .shared)
        let loader = RemoteLocationsLoader(url: url, client: client)
        return LocationsViewModel(loader: loader)
    }
}
