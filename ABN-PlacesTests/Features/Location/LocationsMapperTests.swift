//
//  LocationsMapperTests.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation
import Testing
@testable import ABN_Places

struct LocationsMapperTests {
    
    @Test
    func map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeLocationsJSON([])
        let codes = [199, 201, 300, 400, 500]
        
        codes.forEach { code in
            do {
                _ = try LocationsMapper.map(json, from: HTTPURLResponse(statusCode: code))
                Issue.record("Expected error for HTTP \(code)")
            } catch {
                // success
            }
        }
    }
    
    @Test
    func map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        do {
            _ = try LocationsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
            Issue.record("Expected error on invalid JSON")
        } catch {
            // success
        }
    }
    
    @Test
    func map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyJSON = makeLocationsJSON([])
        
        let result = try LocationsMapper.map(emptyJSON, from: HTTPURLResponse(statusCode: 200))
        
        #expect(result == [])
    }
    
    @Test
    func map_deliversLocationsOn200HTTPResponseWithJSONItems() throws {
        let location1 = makeLocation(name: "Amsterdam", lat: 52.3547498, long: 4.8339215)
        let location2 = makeLocation(name: "Mumbai", lat: 19.0823998, long: 72.811146)
        let location3 = makeLocation(name: "Copenhagen", lat: 55.6713442, long: 12.523785)
        let location4 = makeLocation(name: nil, lat: 40.4380638, long: -3.7495758)
        
        let json = makeLocationsJSON([location1.json, location2.json, location3.json, location4.json])
        
        let result = try LocationsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        #expect(result == [location1.model, location2.model, location3.model, location4.model])
    }
    
    // MARK: - Helpers
    
    private func makeLocation(name: String?, lat: Double, long: Double) -> (model: RemoteLocation, json: [String: Any]) {
        let model = RemoteLocation(name: name, latitude: lat, longitude: long)
        let json: [String: Any] = [
            "name": name as Any,
            "lat": lat,
            "long": long
        ].compactMapValues { $0 is NSNull ? nil : $0 }
        
        return (model, json)
    }
    
    private func makeLocationsJSON(_ locations: [[String: Any]]) -> Data {
        let dict = ["locations": locations]
        return try! JSONSerialization.data(withJSONObject: dict)
    }
}
