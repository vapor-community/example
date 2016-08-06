#if os(Linux)

import XCTest
@testable import AppTestSuite

XCTMain([
    testCase(BasicTests.allTests),
])

#endif
