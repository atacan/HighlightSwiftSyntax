//
// https://github.com/atacan
// 22.10.22

import Cocoa
import Foundation
import SwiftSyntax
import SwiftSyntaxParser

struct Word: Equatable, Hashable {
    var token: TokenSyntax
    var kind: HighlightKind
}

struct ParsedCode {
    var words = [Word]()
//    var enhancableWords = [Word]()
    var enhancableWords = Set<Word>()

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
        parsedCode.enhancableWords.insert(member)

        for token in node.tokens {
            // if the token is for the base then add it, otherwise root is repeated for each nested member
            if token.text == base {
                let kind: HighlightKind = base.first?.isUppercase ?? false
                    ? .typeUsed
                    : .plainText
                parsedCode.enhancableWords.insert(Word(token: token, kind: kind))
            }
        }
        return super.visit(node)
    }

    override func visit(_ node: TupleExprElementSyntax) -> Syntax {
        if let label = node.label {
            parsedCode.enhancableWords.insert(Word(token: label, kind: .argument))
        }
        return super.visit(node)
    }

    override func visit(_ node: FunctionParameterSyntax) -> Syntax {

        if let firstName = node.firstName {
            parsedCode.enhancableWords.insert(Word(token: firstName, kind: .argumentLabel))
        }

        if let secondName = node.secondName {
            parsedCode.enhancableWords.insert(Word(token: secondName, kind: .parameterName))
        }

        return super.visit(node)
    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        node.tokens.forEach { token in
            print(token.text, "text >\(token.text)<", "expression >\(node.calledExpression.description)<")
            debugToken(token)
            if token.text == node.calledExpression.description.trimmingCharacters(in: .whitespacesAndNewlines) {
                if token.text.first?.isUppercase ?? false {
                    parsedCode.enhancableWords.insert(Word(token: token, kind: .typeUsed))
                } else {
                    print("not uppercase")
                    parsedCode.enhancableWords.insert(Word(token: token, kind: .functionCall))
                }
            }
        }

        return super.visit(node)
    }
}

func debugToken(_ token: TokenSyntax?) {
    if let token {
        print(
            "token.text", token.text, "token.tokenKind", token.tokenKind, "token.tokenClassification", token.tokenClassification,
            "token.leadingTrivia", token.leadingTrivia, token.leadingTriviaLength,
            "token.trailingTrivia", token.trailingTrivia, token.trailingTriviaLength,
            "\n"
            // , "token.syntaxNodeType", token.syntaxNodeType,
        )
    }
}
