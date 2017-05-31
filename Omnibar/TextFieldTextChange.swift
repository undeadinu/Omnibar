//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

import struct Foundation.NSRange

struct TextFieldTextChange {
    let oldText: String
    let patch: TextFieldTextPatch

    var result: String {

        let replacementRange: Range<String.Index> = {
            let rangeStart = oldText.index(
                oldText.startIndex,
                offsetBy: patch.range.location)
            let rangeEnd = oldText.index(
                rangeStart,
                offsetBy: patch.range.length,
                limitedBy: oldText.endIndex)
                ?? oldText.endIndex
            return rangeStart..<rangeEnd
        }()

        return oldText.replacingCharacters(
            in: replacementRange,
            with: patch.string)
    }
}

struct TextFieldTextPatch {
    let string: String
    let range: NSRange
}