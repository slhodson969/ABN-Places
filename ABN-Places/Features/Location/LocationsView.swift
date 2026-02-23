//
//  LocationsView.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import SwiftUI

public struct LocationsView: View {
    public let locations: [Location]
    public let didSelectCoordinates: (Double, Double) -> Void
    
    @State private var latitudeInput: String = ""
    @State private var longitudeInput: String = ""
    
    public init(
        locations: [Location],
        didSelectCoordinates: @escaping (Double, Double) -> Void
    ) {
        self.locations = locations
        self.didSelectCoordinates = didSelectCoordinates
    }
    
    public var body: some View {
        List {
            
            Section("Locations") {
                ForEach(locations) { location in
                    Button {
                        didSelectCoordinates(location.latitude, location.longitude)
                    } label: {
                        HStack {
                            Text(location.name ?? "Unnamed")
                            Spacer()
                            Text("(\(location.latitude.coordinateString), \(location.longitude.coordinateString))")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        "\(location.name ?? "Unnamed location"), latitude \(location.latitude.coordinateString), longitude \(location.longitude.coordinateString)"
                    )
                    .accessibilityHint("Double tap to select this location.")
                }
            }
            
            Section("Enter your own coordinates") {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Latitude")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter latitude", text: $latitudeInput)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Latitude")
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Longitude")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter longitude", text: $longitudeInput)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .accessibilityLabel("Longitude")
                }
                
                Button("Submit Coordinates") {
                    guard let lat = latitudeValue,
                          let long = longitudeValue
                    else { return }
                    
                    didSelectCoordinates(lat, long)
                    latitudeInput = ""
                    longitudeInput = ""
                }
                .disabled(!isInputValid)
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Submits the entered latitude and longitude.")
                .accessibilityValue(
                    isInputValid
                    ? "Enabled"
                    : "Disabled until valid latitude and longitude are entered"
                )
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.insetGrouped)
    }
    
    private var latitudeValue: Double? {
        Double(latitudeInput.replacingOccurrences(of: ",", with: "."))
    }

    private var longitudeValue: Double? {
        Double(longitudeInput.replacingOccurrences(of: ",", with: "."))
    }

    private var isInputValid: Bool {
        latitudeValue != nil && longitudeValue != nil
    }
}

#Preview {
    LocationsView(
        locations: [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.811146),
            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785),
            Location(name: nil, latitude: 40.4380638, longitude: -3.7495758)
        ]
    ) { lat, long in
        print("Selected coordinates: (\(lat), \(long))")
    }
}
