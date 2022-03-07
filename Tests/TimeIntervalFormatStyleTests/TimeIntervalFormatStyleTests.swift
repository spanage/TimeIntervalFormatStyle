import XCTest
@testable import TimeIntervalFormatStyle

final class TimeIntervalFormatStyleTests: XCTestCase {
    
    let formatWithMSStyle = TimeInterval.TimeIntervalFormatStyle(true)
    let formatWithoutMSStyle = TimeInterval.TimeIntervalFormatStyle(false)
    
    func testParseEmpty() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse(""), 0)
    }
    
    func testParseValidNoMS() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("3:02:55"), 10975.0)
    }
    
    func testParseValidWithMS() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0:10:01.345"), 601.345)
    }
    
    func testParseInvalidSeconds() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0:10:91.345"), 0)
    }
    
    func testParseInvalidMinutes() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("3:62:55"), 0)
    }
    
    func testParseHasBeyondMilliseconds() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("3:02:55.823331"), 10975.823)
    }
    
    func testParseInvalidDelim() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("3-12-55"), 0)
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("3😬12-55"), 0)
    }
    
    func testParseInvalidDigits() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0:1b:21.345"), 0)
    }
    
    // This should pass as it does -- we allow users to mess up and make our best guess
    func testParseMixedUpDelim() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0.10.01:345"), 601.345)
    }
    
    func testParseForgotPadding() throws {
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0:2:1.8"), 121.8)
        XCTAssertEqual(try TimeIntervalParseStrategy().parse("0:2:1.88"), 121.88)
    }
    
    func testInputBasic() throws {
        XCTAssertEqual(formatWithMSStyle.format(10975.0), "3:02:55.000")
        XCTAssertEqual(formatWithoutMSStyle.format(10975.0), "3:02:55")
    }
    
    func testInputZero() throws {
        XCTAssertEqual(formatWithMSStyle.format(0), "0:00:00.000")
        XCTAssertEqual(formatWithoutMSStyle.format(0), "0:00:00")
    }
    
    func testInputLessThanOneSecond() throws {
        XCTAssertEqual(formatWithMSStyle.format(0.001), "0:00:00.001")
        XCTAssertEqual(formatWithoutMSStyle.format(0.001), "0:00:00")
    }
    
    func testInputSecondsOnly() throws {
        XCTAssertEqual(formatWithMSStyle.format(19), "0:00:19.000")
        XCTAssertEqual(formatWithoutMSStyle.format(19), "0:00:19")
    }
    
    func testInputHasBeyondMilliseconds() throws {
        XCTAssertEqual(formatWithMSStyle.format(1.801555), "0:00:01.801")
        XCTAssertEqual(formatWithoutMSStyle.format(1.801555), "0:00:01")
    }
}
