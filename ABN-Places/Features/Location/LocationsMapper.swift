//
//  LocationsMapper.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public final class LocationsMapper {
    
    private struct Root: Decodable {
        let locations: [RemoteLocation]
        
        struct RemoteLocation: Decodable {
            let name: String?
            let lat: Double
            let long: Double
            
            var model: Location {
                Location(name: name, latitude: lat, longitude: long)
            }
        }
        
        var items: [Location] {
            locations.map { $0.model }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Location] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.items
    }
}
