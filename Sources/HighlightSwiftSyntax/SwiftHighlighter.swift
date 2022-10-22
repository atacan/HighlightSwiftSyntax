//
// https://github.com/atacan
// 22.10.22

import Cocoa
import Foundation
import SwiftSyntaxParser

public struct SwiftHighlighter {
    enum HighlighterError: Error {
        case stringFromData
    }

    public init(inputCode: String) {
        self.inputCode = inputCode
    }

    let inputCode: String

    private func highlightToMutable() throws -> NSMutableAttributedString {
        let rewriter = SwiftHighlighterRewriter()
        let inputSource = try SyntaxParser.parse(source: inputCode)
        _ = rewriter.visit(inputSource)

        let colorizer = Colorizer(inputCode: inputCode, rangeToKind: rewriter.parsedCode.rangeToKind)
        let output = colorizer.highlightedCode()
        return output
    }

    public func highlight() throws -> NSAttributedString {
        try NSAttributedString(attributedString: highlightToMutable())
    }

    public func toHtml() throws -> String {
        // make monospace
        let output = try highlightToMutable()
//        let attributes = [NSAttributedString.Key.font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)]
        let attributes = [NSAttributedString.Key.font: NSFont(name: "Menlo", size: 11) ?? NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)]
        output.addAttributes(attributes, range: NSRange(location: 0, length: output.length))
        // convert to Html
        let htmlData = try output.data(from: NSRange(location: 0, length: output.length),
                                       documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html])
        if let html = String(data: htmlData, encoding: String.Encoding.utf8) {
            return html
        } else {
            throw HighlighterError.stringFromData
        }
    }
}
