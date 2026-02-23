//
//  LocationsLoader.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

protocol LocationsLoader {
    func load() async throws -> [Location]
}
