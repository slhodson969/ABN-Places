//
//  Stub.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

public protocol Stub {
    static func stub(for request: URLRequest) throws -> (Data, URLResponse)
}
