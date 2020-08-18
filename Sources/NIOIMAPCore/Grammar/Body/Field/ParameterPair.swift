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

import struct NIO.ByteBuffer

extension BodyStructure {
    public struct ParameterPair: Equatable {
        public var field: String
        public var value: String

        public init(field: String, value: String) {
            self.field = field
            self.value = value
        }
    }
}

// MARK: - Encoding

extension EncodeBuffer {
    @discardableResult mutating func writeBodyParameterPairs(_ params: [BodyStructure.ParameterPair]) -> Int {
        guard params.count > 0 else {
            return self.writeNil()
        }
        return self.writeArray(params) { (element, buffer) in
            buffer.writeParameterPair(element)
        }
    }

    @discardableResult mutating func writeParameterPair(_ pair: BodyStructure.ParameterPair) -> Int {
        self.writeIMAPString(pair.field) +
            self.writeSpace() +
            self.writeIMAPString(pair.value)
    }
}