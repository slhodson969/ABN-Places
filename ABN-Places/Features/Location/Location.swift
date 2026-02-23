//
//  Location.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public struct Location: Identifiable, Equatable {
    public let id: UUID
    public let name: String?
    public let latitude: Double
    public let longitude: Double

    public init(id: UUID = UUID(), name: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
