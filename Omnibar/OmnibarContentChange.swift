//  Copyright © 2017 Christian Tietze. All rights reserved. Distributed under the MIT License.

public enum OmnibarContentChange: Equatable {

    case replacement(text: String)
    case continuation(text: String, remainingAppendix: String)

    init(base content: OmnibarContent, change: TextFieldTextChange) {

        self = {
            switch content {
            case .suggestion:

                guard change.method == .insertion else { return .replacement(text: change.result) }

                let originalText = content.string
                let newText = change.result

                guard let matchedRange = originalText.range(of: newText, options: .caseInsensitive),
                    matchedRange.lowerBound == originalText.startIndex
                    else {
                        return .replacement(text: newText) }

                return .continuation(
                    text: change.result,
                    remainingAppendix: originalText.removingSubrange(matchedRange))
            default:
                return .replacement(text: change.result)
            }
        }()
    }
}

extension String {

    func removingSubrange(_ bounds: Range<Index>) -> String {

        return self.replacingCharacters(in: bounds, with: "")
    }
}

public func ==(lhs: OmnibarContentChange, rhs: OmnibarContentChange) -> Bool {

    switch (lhs, rhs) {
    case (.replacement(text: let lText),
          .replacement(text: let rText)):
        return lText == rText

    case let (.continuation(text: lText, remainingAppendix: lAppendix),
              .continuation(text: rText, remainingAppendix: rAppendix)):
        return lText == rText && lAppendix == rAppendix

    default:
        return false
    }
}