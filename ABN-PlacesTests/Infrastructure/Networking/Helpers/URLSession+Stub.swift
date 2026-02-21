//
//  StubProtocol.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public extension URLSession {

    private class StubProtocol<S: Stub>: URLProtocol {

        override class func canInit(with request: URLRequest) -> Bool { true }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

        override func startLoading() {
            guard let client else { return }

            do {
                let (data, response) = try S.stub(for: request)
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client.urlProtocol(self, didLoad: data)
                client.urlProtocolDidFinishLoading(self)
            } catch {
                client.urlProtocol(self, didFailWithError: error)
            }
        }

        override func stopLoading() {}
    }

    static func stubbed<S: Stub>(with stub: S.Type) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [StubProtocol<S>.self]
        return URLSession(configuration: config)
    }
}
