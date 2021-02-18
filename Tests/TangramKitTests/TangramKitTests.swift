import XCTest
@testable import TangramKit

final class TangramKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TangramKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
