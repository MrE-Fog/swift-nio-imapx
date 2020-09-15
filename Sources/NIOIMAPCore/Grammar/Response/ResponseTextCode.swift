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

// TODO: Convert to struct
/// IMAPv4 `resp-text-code`
public enum ResponseTextCode: Equatable {
    case alert
    case badCharset([String])
    case capability([Capability])
    case parse
    case permanentFlags([PermanentFlag])
    case readOnly
    case readWrite
    case tryCreate
    case uidNext(Int)
    case uidValidity(Int)
    case unseen(Int)
    case namespace(NamespaceResponse)
    case uidAppend(ResponseCodeAppend)
    case uidCopy(ResponseCodeCopy)
    case uidNotSticky
    case useAttribute
    case other(String, String?)
    case notSaved // RFC 5182
    case closed
    case noModifierSequence
    case modified(SequenceSet)
    case highestModifierSequence(ModifierSequenceValue)
}

// MARK: - Encoding

extension EncodeBuffer {
    @discardableResult mutating func writeResponseTextCode(_ code: ResponseTextCode) -> Int {
        switch code {
        case .alert:
            return self.writeString("ALERT")
        case .badCharset(let charsets):
            return self.writeResponseTextCode_badCharsets(charsets)
        case .capability(let data):
            return self.writeCapabilityData(data)
        case .parse:
            return self.writeString("PARSE")
        case .permanentFlags(let flags):
            return
                self.writeString("PERMANENTFLAGS ") +
                self.writePermanentFlags(flags)
        case .readOnly:
            return self.writeString("READ-ONLY")
        case .readWrite:
            return self.writeString("READ-WRITE")
        case .tryCreate:
            return self.writeString("TRYCREATE")
        case .uidNext(let number):
            return self.writeString("UIDNEXT \(number)")
        case .uidValidity(let number):
            return self.writeString("UIDVALIDITY \(number)")
        case .unseen(let number):
            return self.writeString("UNSEEN \(number)")
        case .other(let atom, let string):
            return self.writeResponseTextCode_other(atom: atom, string: string)
        case .namespace(let namesapce):
            return self.writeNamespaceResponse(namesapce)
        case .uidCopy(let data):
            return self.writeResponseCodeCopy(data)
        case .uidAppend(let data):
            return self.writeResponseCodeAppend(data)
        case .uidNotSticky:
            return self.writeString("UIDNOTSTICKY")
        case .useAttribute:
            return self.writeString("USEATTR")
        case .notSaved:
            return self.writeString("NOTSAVED")
        case .closed:
            return self.writeString("CLOSED")
        case .noModifierSequence:
            return self.writeString("NOMODSEQ")
        case .modified(let set):
            return self.writeString("MODIFIED ") + self.writeSequenceSet(set)
        case .highestModifierSequence(let val):
            return self.writeString("HIGHESTMODSEQ ") + self.writeModifierSequenceValue(val)
        }
    }

    private mutating func writeResponseTextCode_badCharsets(_ charsets: [String]) -> Int {
        self.writeString("BADCHARSET") +
            self.writeIfArrayHasMinimumSize(array: charsets) { (charsets, self) -> Int in
                self.writeSpace() +
                    self.writeArray(charsets) { (charset, self) in
                        self.writeString(charset)
                    }
            }
    }

    private mutating func writeResponseTextCode_other(atom: String, string: String?) -> Int {
        self.writeString(atom) +
            self.writeIfExists(string) { (string) -> Int in
                self.writeString(" \(string)")
            }
    }
}
