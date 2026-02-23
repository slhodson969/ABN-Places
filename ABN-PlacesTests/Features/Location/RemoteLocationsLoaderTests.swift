//
//  RemoteLocationsLoaderTests.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

import Foundation
import Testing
@testable import ABN_Places

@MainActor
struct RemoteLocationsLoaderTests {

    @Test
    func load_deliversLocationsOnSuccess() async throws {
        let url = anyURL()
        let expectedLocations = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
        let client = HTTPClientSpy()
        
        let jsonData = try JSONSerialization.data(
            withJSONObject: [
                "locations": expectedLocations.map { location -> [String: Any] in
                    var dict: [String: Any] = [
                        "lat": location.latitude,
                        "long": location.longitude
                    ]
                    if let name = location.name {
                        dict["name"] = name
                    }
                    return dict
                }
            ],
            options: []
        )
        
        client.result = .success((jsonData, HTTPURLResponse(statusCode: 200)))
        
        let loader = RemoteLocationsLoader(url: url, client: client)
        
        let locations = try await loader.load()
        
        #expect(
            locations.map { ($0.name, $0.latitude, $0.longitude) }
                .elementsEqual(
                    expectedLocations.map { ($0.name, $0.latitude, $0.longitude) },
                    by: { $0 == $1 }
                )
        )
        #expect(client.lastRequest?.url == url)
    }

    @Test
    func load_throwsErrorOnNon200HTTPResponse() async throws {
        let url = anyURL()
        let client = HTTPClientSpy()
        client.result = .success((Data(), HTTPURLResponse(statusCode: 404)))

        let loader = RemoteLocationsLoader(url: url, client: client)

        do {
            _ = try await loader.load()
            Issue.record("Expected loader to throw on 404 response")
        } catch {
            // Success: loader throws
        }
    }

    @Test
    func load_throwsErrorOnClientFailure() async throws {
        let url = anyURL()
        let client = HTTPClientSpy()
        client.result = .failure(URLError(.notConnectedToInternet))

        let loader = RemoteLocationsLoader(url: url, client: client)

        do {
            _ = try await loader.load()
            Issue.record("Expected loader to throw on client failure")
        } catch let error as URLError {
            #expect(error.code == .notConnectedToInternet)
        } catch {
            Issue.record("Unexpected error type \(error)")
        }
    }

    // MARK: - Helpers

    private final class HTTPClientSpy: HTTPClient {
        var lastRequest: URLRequest?
        var result: Result<(Data, HTTPURLResponse), Error>?

        func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
            lastRequest = request
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            case .none:
                fatalError("Result must be set before calling send")
            }
        }
    }
}
