//
// https://github.com/atacan
// 30.10.22
	
import Cocoa
import Foundation
import SwiftHtml
import SwiftSyntax
import Prelude
import SwiftSyntaxParser
import SwiftCss

public enum HtmlContainer {
case preOnly, preCode
}

public enum HtmlOutputType{
    case fullHtmlWithStyle, codeOnly
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
            return try Pre(Code(htmlContent())) |> render(_:)
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
        if !cssClass.isEmpty {
            return Span(content).class(cssClass)
        } else {
            return Text(content)
        }
    }
    
    public func styleCss() -> String{
        Style(styleContent())
        |> render(_:)
    }
    func styleContent() -> String {
        Stylesheet {
            Media {
//                Element(.pre) {
//                    Display(.block)
//                    WhiteSpace(.pre)
//                    BackgroundColor(.black)
//                }
                HighlightKind.allCases.map {kind in
                    Selector("pre code .\(cssClass(kind: kind))") {
                        Color(CSSColor(stringLiteral: amazeMidnightColor(kind: kind) |> hexColor(_:) ))
                    }
                }
            }
        } |> render(_:)
        
//        return ""
    }
}


func cssClass(kind: HighlightKind) -> String {
    switch kind {
    case .keyWord:
        return "keyWord"
    case .string:
        return "string"
    case .numeric:
        return "numeric"
    case .typeDeclaration:
        return "typeDeclaration"
    case .otherDeclaration:
        return "otherDeclaration"
    case .typeUsed:
        return "typeUsed"
    case .functionCall:
        return "functionCall"
    case .member:
        return "member"
    case .argument:
        return "argument"
    case .codeComment:
        return "codeComment"
    case .documentComment:
        return "documentComment"
    case .parameterName:
        return "parameterName"
    case .argumentLabel:
        return "argumentLabel"
    case .plainText:
        return ""
    case .preprocessor:
        return "preprocessor"
    case .snippetPlaceholder:
        return "snippetPlaceholder"
    case .whiteSpace:
        return "whiteSpace"
    }
}

private func render(_ tag: Tag) -> String {
    let doc = Document(.unspecified, {tag})
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
