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

public struct RenameParameter: Equatable {
    public var name: String
    public var value: TaggedExtensionValue?

    public init(name: String, value: TaggedExtensionValue? = nil) {
        self.name = name
        self.value = value
    }
}

// MARK: - Encoding

extension ByteBuffer {
    @discardableResult mutating func writeRenameParameters(_ params: [RenameParameter]) -> Int {
        guard params.count > 0 else {
            return 0
        }
        return
            self.writeSpace() +
            self.writeArray(params) { (param, self) -> Int in
                self.writeRenameParameter(param)
            }
    }

    @discardableResult mutating func writeRenameParameter(_ param: RenameParameter) -> Int {
        self.writeRenameParameterName(param.name) +
            self.writeIfExists(param.value) { (value) -> Int in
                self.writeSpace() +
                    self.writeTaggedExtensionValue(value)
            }
    }
}
