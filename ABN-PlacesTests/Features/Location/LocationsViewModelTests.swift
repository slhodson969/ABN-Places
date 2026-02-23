//
//  LocationsViewModelTests.swift
//  ABN-Places
//
//  Created by Scott Hodson on 23/02/2026.
//

import Foundation
import Testing
@testable import ABN_Places

@MainActor
struct LocationsViewModelTests {

    @Test
    func load_deliversLocationsOnSuccess() async throws {
        let expectedLocations = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468)
        ]
        let loader = MockLocationsLoader(result: .success(expectedLocations))
        let viewModel = LocationsViewModel(loader: loader)

        await viewModel.load()

        #expect(viewModel.locations == expectedLocations)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    func load_setsIsLoadingWhileLoading() async throws {
        class ControllableLoader: LocationsLoader {
            var continuation: CheckedContinuation<[Location], Error>?
            func load() async throws -> [Location] {
                try await withCheckedThrowingContinuation { cont in
                    self.continuation = cont
                }
            }
        }

        let loader = ControllableLoader()
        let viewModel = await MainActor.run { LocationsViewModel(loader: loader) }

        let task = Task { await viewModel.load() }

        await MainActor.run {
            #expect(viewModel.isLoading == true)
        }

        loader.continuation?.resume(returning: [])

        await task.value
        
        await MainActor.run {
            #expect(viewModel.isLoading == false)
        }
    }

    @Test
    func load_deliversErrorMessageOnFailure() async throws {
        let loader = MockLocationsLoader(result: .failure(MockError()))
        let viewModel = LocationsViewModel(loader: loader)

        await viewModel.load()

        #expect(viewModel.locations.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == "mock error")
    }

    // MARK: - Helpers

    private struct MockLocationsLoader: LocationsLoader {
        let result: Result<[Location], Error>

        func load() async throws -> [Location] {
            switch result {
            case let .success(locations): return locations
            case let .failure(error): throw error
            }
        }
    }

    private struct MockError: LocalizedError {
        var errorDescription: String? { "mock error" }
    }
}
