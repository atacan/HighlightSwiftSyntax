//
// https://github.com/atacan
// 22.10.22

import Cocoa
import Foundation
import SwiftSyntax
import SwiftSyntaxParser

struct Word: Equatable {
    var token: TokenSyntax
    var kind: HighlightKind
}

struct ParsedCode {
    var words = [Word]()
    var enhancableWords = [Word]()

    var enhancedWords: [Word] {
        var outputWords = words
        for enhancable in enhancableWords {
            if enhancable.kind != .plainText,
               let toReplace = outputWords.firstIndex(where: { word in word.token == enhancable.token })
            {
                outputWords[toReplace] = enhancable
            }
        }

        return outputWords
    }
}

class SwiftHighlighterRewriter: SyntaxRewriter {
    var parsedCode = ParsedCode()

    override func visit(_ token: TokenSyntax) -> Syntax {
        let kind = HighlightKind(swiftSyntax: token)
        let word = Word(token: token, kind: kind)
        parsedCode.words.append(word)
        return super.visit(token)
    }

    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        let base: String = node.base?.description ?? ""
        let member = Word(token: node.name, kind: .member)
        parsedCode.enhancableWords.append(member)

        for token in node.tokens {
            // if the token is for the base then add it, otherwise root is repeated for each nested member
            if token.text == base {
                let kind: HighlightKind = base.first?.isUppercase ?? false
                    ? .typeUsed
                    : .plainText
                parsedCode.enhancableWords.append(Word(token: token, kind: kind))
            }
        }
        return super.visit(node)
    }

    override func visit(_ node: TupleExprElementSyntax) -> Syntax {
        if let label = node.label {
            parsedCode.enhancableWords.append(Word(token: label, kind: .argument))
        }
        return super.visit(node)
    }
}

func debugToken(_ token: TokenSyntax) {
    print(
        "token.text", token.text, "token.tokenKind", token.tokenKind, "token.tokenClassification", token.tokenClassification,
        "token.leadingTrivia", token.leadingTrivia, token.leadingTriviaLength,
        "token.trailingTrivia", token.trailingTrivia, token.trailingTriviaLength,
        "\n"
        // , "token.syntaxNodeType", token.syntaxNodeType,
    )
}


