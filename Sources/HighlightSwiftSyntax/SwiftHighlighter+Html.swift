//
// https://github.com/atacan
// 30.10.22

import Cocoa
import Foundation
import Prelude
import SwiftCss
import SwiftHtml
import SwiftSyntax
import SwiftSyntaxParser

public enum HtmlContainer {
    case preOnly
    case preCode
}

public enum HtmlOutputType {
    case fullHtmlWithStyle
    case codeOnly
}

extension SwiftHighlighter {
//    public func html(outputType: HtmlOutputType = .codeOnly, container: HtmlContainer = .preCode) throws -> Tag {
//        switch outputType {
//        case .fullHtmlWithStyle:
//            return try fullHtml(container: container)
//        case .codeOnly:
//            return try htmlContainer(container: container)
//        }
//    }
//
//    private func fullHtml(container: HtmlContainer) throws -> Tag {
//        Html {
//            Head {
//                Style("")
//            }
//            Body {
//                try htmlContainer(container: container)
//            }
//        }
//    }

    public func html(container: HtmlContainer = .preCode) throws -> String {
        switch container {
        case .preOnly:
            return try Pre(htmlContent()) |> render(_:)
        case .preCode:
            return try Pre(
                Code(htmlContent()).class("language-swift")
            ) |> render(_:)
        }
    }

    private func htmlContent() throws -> [Tag] {
        let rewriter = SwiftHighlighterRewriter()
        let inputSource = try SyntaxParser.parse(source: inputCode)
        _ = rewriter.visit(inputSource)

        var output = [Tag]()
        let wordsToHighlight = rewriter.parsedCode.enhancedWords

        for word in wordsToHighlight {
            let wordAttributed = appendableHtml(word)
            output.append(contentsOf: wordAttributed)
        }

        return output
    }

    private func appendableHtml(_ word: Word) -> [Tag] {
        var output = [Tag]()

        let prefix = word.token.leadingTrivia |> triviaTag(_:)
        let suffix = word.token.trailingTrivia |> triviaTag(_:)

        let wordAttributed = classedText(kind: word.kind, content: word.token.text)

        output.append(contentsOf: prefix)
        output.append(wordAttributed)
        output.append(contentsOf: suffix)

        return output
    }

    private func triviaTag(_ trivia: Trivia) -> [Tag] {
        var output = [Tag]()
        trivia.forEach { piece in
            let (kind, content) = HighlightKind.convertTriviaPiece(piece)
            let tag = classedText(kind: kind, content: content)
            output.append(tag)
        }

        return output
    }

    private func classedText(kind: HighlightKind, content: String) -> Tag {
        let cssClass = cssClass(kind: kind)
        if kind != .plainText {
            return Span(content).class(cssClass)
        } else {
            return Text(content)
        }
    }

    public func styleCss() -> String {
        Style(styleContent())
            |> render(_:)
    }

    func styleContent() -> String {
        Stylesheet {
            Media {
                Element(.pre) {
                    Display(.block)
                    WhiteSpace(.pre)
                    BackgroundColor(.black)
                    Color(CSSColor.snow)
                    Padding(top: .px(15), right: .px(20), bottom: .px(15), left: .px(20))
                }
                HighlightKind.allCases.map { kind in
                    Elements(inside: [HTMLElement.pre, HTMLElement.code, kind]) {
                        Color(CSSColor(stringLiteral: kind |> amazeMidnightColor >>> hexColor(_:)))
                        kind |> cssFont
                    }
                }
            }
        } |> render(_:)
    }
}

func cssClass(kind: HighlightKind) -> String {
    return "\(kind)"
}

func cssFont(kind: HighlightKind) -> [Property] {
    switch kind {
    case .documentComment:
        return [FontFamily(FontFamilyValue.family("sans-serif")), FontSize("calc(100% - 1px)")]
    default:
        return []
    }
}

private func render(_ tag: Tag) -> String {
    let doc = Document(.unspecified) { tag }
    return DocumentRenderer(minify: true, indent: 2).render(doc)
}

func hexColor(_ nsColor: NSColor) -> String {
    guard let rgbColor = nsColor.usingColorSpace(.deviceRGB) else {
        return "FFFFFF"
    }
    let red = Int(round(rgbColor.redComponent * 0xFF))
    let green = Int(round(rgbColor.greenComponent * 0xFF))
    let blue = Int(round(rgbColor.blueComponent * 0xFF))
    let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
    return hexString as String
}

private func render(_ styleSheet: Stylesheet) -> String {
    StylesheetRenderer(minify: false, indent: 4).render(styleSheet)
}
