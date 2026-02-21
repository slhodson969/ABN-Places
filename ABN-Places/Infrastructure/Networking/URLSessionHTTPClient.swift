//
//  URLSessionHTTPClient.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedResponseError: Error {}
    
    nonisolated public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UnexpectedResponseError()
        }
        
        return (data, httpResponse)
    }
}
