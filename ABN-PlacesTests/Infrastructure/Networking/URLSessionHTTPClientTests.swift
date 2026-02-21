//
//  ABN_PlacesTests.swift
//  ABN-PlacesTests
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation
import Testing
@testable import ABN_Places

struct URLSessionHTTPClientTests {

    // MARK: - Success
    
    @Test
    func send_returnsDataAndHTTPURLResponse_onSuccess() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: SuccessStub.self)
            weakSUT = sut
            
            let (data, response) = try await sut.send(URLRequest(url: url))
            
            #expect(data == "hello".data(using: .utf8))
            #expect(response.url == url)
            #expect(response.statusCode == 200)
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    @Test
    func send_succeedsWithEmptyData_whenResponseHasNilData() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: EmptyDataStub.self)
            weakSUT = sut
            
            let (data, response) = try await sut.send(URLRequest(url: url))
            
            #expect(data == Data())
            #expect(response.url == url)
            #expect(response.statusCode == 200)
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    // MARK: - Failure

    @Test
    func send_throwsError_onRequestError() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: ErrorStub.self)
            weakSUT = sut
            
            do {
                _ = try await sut.send(URLRequest(url: url))
                Issue.record("Expected error, but got success")
            } catch {
                #expect((error as NSError).domain == "Test")
            }
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    @Test
    func send_throwsError_onNonHTTPURLResponse() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: NonHTTPStub.self)
            weakSUT = sut
            
            do {
                _ = try await sut.send(URLRequest(url: url))
                Issue.record("Expected error due to invalid response")
            } catch {
                // success — only care it throws
            }
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    // MARK: - Request forwarding

    @Test
    func send_performsGETRequestWithURL() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: ObserveRequestStub.self)
            weakSUT = sut
            
            _ = try await sut.send(URLRequest(url: url))
            
            #expect(ObserveRequestStub.capturedRequest?.url == url)
            #expect(ObserveRequestStub.capturedRequest?.httpMethod == "GET")
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    // MARK: - Cancellation

    @Test
    func send_cancelsTask_onCancellation() async throws {
        weak var weakSUT: URLSessionHTTPClient?
        let url = anyURL()
        
        do {
            let sut = makeSUT(stub: SuccessStub.self)
            weakSUT = sut
            
            let task = Task { try await sut.send(URLRequest(url: url)) }
            task.cancel()
            
            do {
                _ = try await task.value
                Issue.record("Expected cancellation error")
            } catch let error as URLError {
                #expect(error.code == .cancelled)
            } catch {
                Issue.record("Expected URLError.cancelled, got \(error)")
            }
        }
        
        #expect(weakSUT == nil, "SUT is leaking memory")
    }

    // MARK: - Helpers

    private func makeSUT<S: Stub>(stub: S.Type) -> URLSessionHTTPClient {
        let session = URLSession.stubbed(with: stub)
        return URLSessionHTTPClient(session: session)
    }
    
    // MARK: - Stubs
    
    private struct SuccessStub: Stub {
        static func stub(for request: URLRequest) throws -> (Data, URLResponse) {
            let data = "hello".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200)
            return (data, response)
        }
    }

    private struct EmptyDataStub: Stub {
        static func stub(for request: URLRequest) throws -> (Data, URLResponse) {
            let response = HTTPURLResponse(url: request.url!, statusCode: 200)
            return (Data(), response)
        }
    }
    
    private struct ErrorStub: Stub {
        static func stub(for request: URLRequest) throws -> (Data, URLResponse) {
            throw NSError(domain: "Test", code: 1)
        }
    }
    
    private struct NonHTTPStub: Stub {
        static func stub(for request: URLRequest) throws -> (Data, URLResponse) {
            return (
                Data(),
                URLResponse(
                    url: request.url!,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil
                )
            )
        }
    }
    
    private struct ObserveRequestStub: Stub {
        static var capturedRequest: URLRequest?
        static func stub(for request: URLRequest) throws -> (Data, URLResponse) {
            capturedRequest = request
            let response = HTTPURLResponse(url: request.url!, statusCode: 200)
            return (Data(), response)
        }
    }
}
