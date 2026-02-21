//
//  LocationsEndpointTests.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation
import Testing
@testable import ABN_Places

struct LocationsEndpointTests {

    @Test
    func test_locationsEndpointURL_withCustomBaseURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let received = LocationsEndpoint.getAll.url(baseURL: baseURL)
        
        #expect(received.scheme == "http")
        #expect(received.host == "base-url.com")
        #expect(received.path.hasSuffix("/locations.json"))
    }
}
