//
//  SharedTestHelpers.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

extension HTTPURLResponse {
    convenience init(url: URL = anyURL(), statusCode: Int) {
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
