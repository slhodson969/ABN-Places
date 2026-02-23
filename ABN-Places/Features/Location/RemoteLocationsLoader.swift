//
//  RemoteLocationsLoader.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

import Foundation

final class RemoteLocationsLoader: LocationsLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async throws -> [Location] {
        let request = URLRequest(url: url)
        
        let (data, response) = try await client.send(request)
        
        let remoteLocations = try LocationsMapper.map(data, from: response)
        
        return remoteLocations.map {
            Location(
                name: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
    }
}
