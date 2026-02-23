# ABN-Places

ABN-Places is an iOS SwiftUI application that displays a list of locations fetched from a remote endpoint. Users can select predefined locations or enter their own coordinates. Selected coordinates are passed back via callbacks, which can be used to trigger deep links to the modified [Wikipedia App](https://github.com/slhodson969/wikipedia-ios-abn).

## Features

- Fetch and display locations from a remote endpoint
- Display coordinates with up to 8 decimal places
- Enter custom coordinates using a text field
- Accessibility support for VoiceOver, including labels and hints
- SwiftUI preview support with mock data for success, loading, and error states
- Fully unit tested using Swift Testing

## Technical Overview

This is a small project, so some architectural choices may appear over-engineered. These decisions were intentional to demonstrate best practices for scaling.

Data flows through the app in a clear, testable manner:

1. RemoteLocationsLoader fetches JSON from the endpoint using a generic HTTP client.
2. LocationsMapper converts the raw JSON into a structured RemoteLocation model.
3. LocationsViewModel exposes the mapped Location data to the UI and handles loading state, errors, and custom coordinate submission.
4. LocationsView is a “dumb” SwiftUI view that displays locations, accepts user input, and reports selections back via a callback.

This architecture keeps networking, mapping, state management, and UI decoupled, making the app highly testable, maintainable, and easy to extend.

## Future Improvements

- Fuller coordinate validation (e.g., bounding latitude [-90, 90] and longitude [-180, 180])
- Allowing coordinates to be selected from a map view rather than manual entry
- Caching retrieved locations locally for offline access
- Storing user-entered coordinates for future use
- UI enhancements for a more polished experience