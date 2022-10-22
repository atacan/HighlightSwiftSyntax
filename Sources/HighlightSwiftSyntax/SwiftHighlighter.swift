//
// https://github.com/atacan
// 22.10.22

import Foundation
import SwiftSyntaxParser

public enum SwiftHighlighter {

    public static func highlight(_ inputCode: String) throws -> NSAttributedString {
        let rewriter = SwiftHighlighterRewriter()
        let inputSource = try SyntaxParser.parse(source: inputCode)
        _ = rewriter.visit(inputSource)

        let colorizer = Colorizer(inputCode: inputCode, rangeToKind: rewriter.parsedCode.rangeToKind)

        return colorizer.highlightedCode()
    }
}
