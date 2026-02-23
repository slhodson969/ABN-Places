//
//  ContentView+PreviewLoaders.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

#if DEBUG
import Foundation

struct PreviewLocationsLoader: LocationsLoader {
    func load() async throws -> [Location] {
        return [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
    }
}

struct DelayedPreviewLocationsLoader: LocationsLoader {
    func load() async throws -> [Location] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        return [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468)
        ]
    }
}

struct ErrorPreviewLocationsLoader: LocationsLoader {
    struct PreviewError: LocalizedError {
        var errorDescription: String? {
            "Unable to fetch locations."
        }
    }
    
    func load() async throws -> [Location] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        throw PreviewError()
    }
}

#endif
