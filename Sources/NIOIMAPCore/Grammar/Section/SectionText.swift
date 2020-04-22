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

extension NIOIMAP {
    
    /// IMAPv4 `section-text`
    public enum SectionText: Equatable {
        case mime
        case message(SectionMessageText)
    }
    
}

// MARK: - Encoding
extension ByteBuffer {
    
    @discardableResult mutating func writeSectionText(_ text: NIOIMAP.SectionText) -> Int {
        switch text {
        case .mime:
            return self.writeString("MIME")
        case .message(let message):
            return self.writeSectionMessageText(message)
        }
    }
}