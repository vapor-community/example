import XCTest
@testable import Example
import HTTP

/**
    These are Application wide tests.
*/
final class ApplicationTests: XCTestCase {
    static let allTests = [
        ("testBasic", testBasic)
    ]

    var app: Application!

    override func setUp() {
        app = Application(testing: true)
    }

    func testBasic() throws {
        let response = try app.respond(to: Request(method: .get, path: "/plaintext"))
        XCTAssertEqual(try response.bodyString(), "Hello, world!")
    }
}
