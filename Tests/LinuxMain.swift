#if os(Linux)

import XCTest
@testable import ExampleTests

XCTMain([
    testCase(BasicTests.allTests),
])

#endif
