//
// https://github.com/atacan
// 22.10.22

import Cocoa
import Foundation
import Prelude
import SwiftSyntax
import SwiftSyntaxParser

public struct SwiftHighlighter {
    public typealias KindToColor = (HighlightKind) -> NSColor
    public typealias KindToFont = (HighlightKind) -> NSFont
    public typealias KindToClass = (HighlightKind) -> String?

    let inputCode: String
    var colorFor: KindToColor
    var fontFor: KindToFont
    var classFor: KindToClass

    public init(inputCode: String,
                colorFor: KindToColor? = nil,
                fontFor: KindToFont? = nil,
                classFor: KindToClass? = nil)
    {
        self.inputCode = inputCode
        if let colorFor {
            self.colorFor = colorFor
        } else {
            self.colorFor = amazeMidnightColor
        }
        if let fontFor {
            self.fontFor = fontFor
        } else {
            self.fontFor = amazeMidnightFont
        }
        if let classFor {
            self.classFor = classFor
        } else {
            self.classFor = cssClass
        }
    }

    public func highlight() throws -> NSMutableAttributedString {
        let rewriter = SwiftHighlighterRewriter()
        let inputSource = try SyntaxParser.parse(source: inputCode)
        _ = rewriter.visit(inputSource)

        let output = NSMutableAttributedString()
        let wordsToHighlight = rewriter.parsedCode.enhancedWords

        for word in wordsToHighlight {
            let wordAttributed = appendableToken(word)
            output.append(wordAttributed)
        }

        return output
    }

    private func appendableToken(_ word: Word) -> NSMutableAttributedString {
        let output = NSMutableAttributedString()

        let prefix = word.token.leadingTrivia |> triviaText(_:)
        let suffix = word.token.trailingTrivia |> triviaText(_:)

        let wordAttributed = coloredText(kind: word.kind, content: word.token.text)

        output.append(prefix)
        output.append(wordAttributed)
        output.append(suffix)

        return output
    }

    private func triviaText(_ trivia: Trivia) -> NSAttributedString {
        let output = NSMutableAttributedString()
        trivia.forEach { piece in
            let (kind, content) = HighlightKind.convertTriviaPiece(piece)
            let wordAttributed = coloredText(kind: kind, content: content)
            output.append(wordAttributed)
        }

        return output
    }

    private func coloredText(kind: HighlightKind, content: String) -> NSAttributedString {
        let color = colorFor(kind)
        let font = fontFor(kind)
        let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        let wordAttributed = NSAttributedString(string: content, attributes: attributes)
        return wordAttributed
    }
}

func amazeMidnightColor(kind: HighlightKind) -> NSColor {
    switch kind {
    case .keyWord:
        return NSColor(red: 0.942109, green: 0, blue: 0.630242, alpha: 1)
    case .string:
        return NSColor(red: 0.988974, green: 0.406344, blue: 0.40599, alpha: 1)
    case .numeric:
        return NSColor(red: 0.469, green: 0.426, blue: 1, alpha: 1)
    case .typeDeclaration:
        return NSColor(red: 0.999996, green: 0.999939, blue: 0.0410333, alpha: 1)
    case .otherDeclaration:
//        return NSColor(red: 0.916967, green: 0.794512, blue: 0.0427856, alpha: 1)
        return NSColor(red: CGFloat(254) / 255, green: CGFloat(251) / 255, blue: CGFloat(83) / 255, alpha: 1)
    case .typeUsed:
        return NSColor(red: 0.131345, green: 0.999677, blue: 0.0236241, alpha: 1)
    case .functionCall:
        return NSColor(red: 0.8, green: 1, blue: 0.4, alpha: 1)
    case .member:
        return NSColor(red: 0.107763, green: 0.826468, blue: 0.407235, alpha: 1)
    case .argument:
        return NSColor(red: CGFloat(66) / 255, green: CGFloat(142) / 255, blue: CGFloat(215) / 255, alpha: 1)
    case .codeComment:
        return NSColor(red: 0.464592, green: 0.52429, blue: 0.589355, alpha: 1)
    case .documentComment:
        return NSColor(red: 0.464592, green: 0.52429, blue: 0.589355, alpha: 1)
    case .parameterName:
        return NSColor(red: CGFloat(241) / 255, green: CGFloat(153) / 255, blue: CGFloat(55) / 255, alpha: 1)
    case .argumentLabel:
        return NSColor(red: CGFloat(66) / 255, green: CGFloat(142) / 255, blue: CGFloat(215) / 255, alpha: 1)
    default:
        return NSColor(red: CGFloat(255) / 255, green: CGFloat(250) / 255, blue: CGFloat(250) / 255, alpha: 1)
    }
}

func amazeMidnightFont(kind: HighlightKind) -> NSFont {
    switch kind {
    case .documentComment:
        return NSFont.labelFont(ofSize: NSFont.systemFontSize(for: .large))
    default:
        return NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize(for: .large), weight: NSFont.Weight.regular)
    }
}
