//
//  TimeIntervalParseStrategy.swift
//  TimeIntervalFormatStyle
//
//  Created by Sommer Panage on 3/6/22.
//

import Foundation

public struct TimeIntervalParseStrategy: ParseStrategy {
    /// Multipliers for each unit in order as they'd be read L to R: hours, minutes, seconds, milliseconds.
    private static let multipliers = [TimeInterval.secondsPerHour, TimeInterval.secondsPerMinute, 1.0, 1.0 / TimeInterval.millisecondsPerSecond]
    
    /// Max values for each unit in order as they'd be read L to R: hours, minutes, seconds, milliseconds.
    private static let maxValues = [Double.greatestFiniteMagnitude, TimeInterval.minutesPerHour - 1, TimeInterval.secondsPerMinute - 1, TimeInterval.millisecondsPerSecond - 1]

    /// Creates an instance of the `ParseOutput` type from `value`.
    /// - Parameter value: Value to convert to `TimeInterval`
    /// - Returns: `TimeInterval`
    public func parse(_ value: String) throws -> TimeInterval {
        var timeComponents = value.components(separatedBy: CharacterSet(charactersIn: ":."))
        guard timeComponents.count <= TimeIntervalParseStrategy.multipliers.count else { return 0 }
        
        // If we have milliseconds (i.e. all 4 time component), we need to
        // coerce it to exactly 3 digits, since we only manage down to milliseconds
        if timeComponents.count == TimeIntervalParseStrategy.multipliers.count {
            let requiredDigits = 3
            var millisecondsString = timeComponents[timeComponents.count - 1]
            let digitCount = millisecondsString.count
            if digitCount < requiredDigits {
                millisecondsString.append(String(repeating: "0", count: requiredDigits - digitCount))
            } else if digitCount > requiredDigits {
                millisecondsString.removeLast(digitCount - requiredDigits)
            }
            timeComponents[timeComponents.count - 1] = millisecondsString
        }
        
        // Now go through our component strings and calculate our TimeInterval.
        var time = 0.0
        for i in 0..<timeComponents.count {
            
            // Bail if we can't parse Doubles
            guard let timeComponent = TimeInterval(timeComponents[i]) else { return 0 }
            
            // Bail if we detect an invalid value
            guard timeComponent <= TimeIntervalParseStrategy.maxValues[i] else { return 0 }
            
            time += timeComponent * TimeIntervalParseStrategy.multipliers[i]
        }
        return time
    }
}
