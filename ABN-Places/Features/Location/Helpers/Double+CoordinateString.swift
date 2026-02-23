//
//  Double+CoordinateString.swift
//  ABN-Places
//
//  Created by Scott Hodson on 21/02/2026.
//

import Foundation

extension Double {
    /// Formats a coordinate value with up to 8 decimal places
    /// (matches typical geo precision and avoids forced trailing zeros)
    var coordinateString: String {
        self.formatted(
            .number.precision(.fractionLength(0...8))
        )
    }
}
