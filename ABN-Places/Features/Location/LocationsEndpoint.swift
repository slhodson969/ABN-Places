//
//  LocationsEndpoint.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public enum LocationsEndpoint {
    case getAll
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getAll:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/locations.json"
            return components.url!
        }
    }
}
