//
//  TimeIntervalFormatStyle.swift
//  TimeIntervalFormatStyle
//
//  Created by Sommer Panage on 3/6/22.
//

import Foundation

public extension TimeInterval {
    struct TimeIntervalFormatStyle {
        
        private var showMilliseconds: Bool = false
        
        /// Constructer to allow extensions to set formatting
        /// - Parameter showMilliseconds: Shows millieconds. Ex: 1:03:44:789 . Default == `false`
        init(_ showMilliseconds: Bool) {
            self.showMilliseconds = showMilliseconds
        }
    }
}

extension TimeInterval.TimeIntervalFormatStyle: ParseableFormatStyle {
    
    /// A `ParseStrategy` that can be used to parse this `FormatStyle`'s output
    public var parseStrategy: TimeIntervalParseStrategy {
        return TimeIntervalParseStrategy()
    }
    
    /// Returns a string based on an input time interval. String format may include milliseconds or not
    /// Example: "2:33:29.632" aka 2 hours, 33 minutes, 29.632 seconds
    public func format(_ value: TimeInterval) -> String {
        let hour = Int((value / TimeInterval.secondsPerHour).rounded(.towardZero))
        let minute = Int((value / TimeInterval.secondsPerMinute).truncatingRemainder(dividingBy: TimeInterval.minutesPerHour))
        let second = Int(value.truncatingRemainder(dividingBy: TimeInterval.secondsPerMinute))
        if showMilliseconds {
            let millisecond = Int((value * TimeInterval.millisecondsPerSecond).truncatingRemainder(dividingBy: TimeInterval.millisecondsPerSecond))
            return String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond) // ex: 10:04:09.689
        } else {
            return String(format:"%d:%02d:%02d", hour, minute, second) // ex: 10:04:09
        }
    }
}
