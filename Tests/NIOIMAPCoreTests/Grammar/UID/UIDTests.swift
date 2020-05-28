//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2020 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import NIO
@testable import NIOIMAPCore
import XCTest

class UIDTests: EncodeTestClass {}

// MARK: - Integer literal

extension UIDTests {
    func testIntegerLiteral() {
        let num: UID = 5
        XCTAssertEqual(num, 5)
    }
}

// MARK: - Comparable

extension UIDTests {
    func testComparable() {
        XCTAssertFalse(UID.max < .max)
        XCTAssertFalse(UID.max < 999)
        XCTAssertTrue(UID.max > 999)
        XCTAssertTrue(UID(1) < 999) // use .number to force type
    }
}

// MARK: - Encoding

extension UIDTests {
    func testEncode_max() {
        let expected = "4294967295"
        let size = self.testBuffer.writeUID(.max)
        XCTAssertEqual(size, expected.utf8.count)
        XCTAssertEqual(expected, self.testBufferString)
    }

    func testEncode_number() {
        let expected = "1234"
        let size = self.testBuffer.writeUID(1234)
        XCTAssertEqual(size, expected.utf8.count)
        XCTAssertEqual(expected, self.testBufferString)
    }
}