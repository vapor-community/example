import XCTest
@testable import Example
import Vapor
import HTTP
import URI

/**
    These are controller specific tests
    concerning the `BasicController`.
*/
final class BasicTests: XCTestCase {
    static let allTests = [
        ("testWelcome", testWelcome),
        ("testPlaintext", testPlaintext)
    ]

    var basic: BasicController!
    var drop: Droplet!

    override func setUp() {
        drop = Droplet(arguments: ["--env=testing"])
    	basic = BasicController(droplet: drop)
    }

    func testWelcome() throws {
        let response = try basic.welcome(Request())
        XCTAssert(try response.bodyString().contains("Powered by Swift."))
    }

    func testPlaintext() throws {
    	let response = try basic.plaintext(Request())
        XCTAssertEqual(try response.bodyString(), "Hello, world!")
    }
}
