//
// https://github.com/atacan
// 22.10.22

import Cocoa
import Foundation
import SwiftSyntax
import SwiftSyntaxParser

public enum MyWordKind {
    case keyWord
    case plainText
    case string
    case numeric
    case typeUsed
    case typeDeclaration
    case otherDeclaration
    case functionCall
    case member
    case argument

    init(swiftSyntaxTokenKind: TokenKind) {
        switch swiftSyntaxTokenKind {
        case _ where swiftSyntaxTokenKind.isKeyword:
            self = .keyWord
        case .privateKeyword, .publicKeyword:
            self = .keyWord
        case .multilineStringQuote, .stringQuote, .stringSegment:
            self = .string
        case .floatingLiteral, .integerLiteral:
            self = .numeric
        default:
            self = .plainText
        }
    }
}

public struct ParsedCode {
    public var rangeToKind = [NSRange: MyWordKind]()
}

public struct Colorizer {
    public init(inputCode: String, rangeToKind: [NSRange: MyWordKind]) {
        self.inputCode = inputCode
        self.rangeToKind = rangeToKind
    }

    let inputCode: String
    let rangeToKind: [NSRange: MyWordKind]

    func colorFor(tokenKind: MyWordKind) -> NSColor {
        switch tokenKind {
        case .keyWord:
            return NSColor(red: 0.942109, green: 0, blue: 0.630242, alpha: 1)
        case .string:
            return NSColor(red: 0.988974, green: 0.406344, blue: 0.40599, alpha: 1)
        case .numeric:
            return NSColor(red: 0.469, green: 0.426, blue: 1, alpha: 1)
        case .typeDeclaration:
            return NSColor(red: 0.999996, green: 0.999939, blue: 0.0410333, alpha: 1)
        case .otherDeclaration:
            return NSColor(red: 0.916967, green: 0.794512, blue: 0.0427856, alpha: 1)
        case .typeUsed:
            return NSColor(red: 0.131345, green: 0.999677, blue: 0.0236241, alpha: 1)
        case .functionCall:
            return NSColor(red: 0.8, green: 1, blue: 0.4, alpha: 1)
        case .member:
            return NSColor(red: 0.107763, green: 0.826468, blue: 0.407235, alpha: 1)
        case .argument:
            return NSColor(red: CGFloat(66) / 255, green: CGFloat(142) / 255, blue: CGFloat(215) / 255, alpha: 1)
        default:
            return NSColor.textColor
        }
    }

    public func highlightedCode() -> NSAttributedString {
        let attributedInput = NSMutableAttributedString(string: inputCode)
        for (range, kind) in rangeToKind {
            let color = colorFor(tokenKind: kind)
            let attributes = [NSAttributedString.Key.foregroundColor: color]
            attributedInput.addAttributes(attributes, range: range)
        }
        return attributedInput
    }
}

protocol HasIdentifier {
    var identifier: TokenSyntax { get }
}

extension ClassDeclSyntax: HasIdentifier {}
extension StructDeclSyntax: HasIdentifier {}
extension ProtocolDeclSyntax: HasIdentifier {}
extension EnumDeclSyntax: HasIdentifier {}
// extension VariableDeclSyntax: HasIdentifier {}

public class SwiftHighlighterRewriter: SyntaxRewriter {
    public var parsedCode = ParsedCode()
    public var debugDict = [Int: TokenKind]()

    private func updateDict(location: Int, length: Int, kind: MyWordKind) {
        let range = NSRange(location: location, length: length)

        if !parsedCode.rangeToKind.keys.contains(range) {
            parsedCode.rangeToKind[range] = kind
        }
    }

    private func typeDeclaration(_ node: HasIdentifier) {
        updateDict(location: node.identifier.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.identifier.contentLength.utf8Length,
                   kind: .typeDeclaration)
    }

    // MARK: - Overrides

    override public func visit(_ token: TokenSyntax) -> Syntax {
        updateDict(location: token.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: token.contentLength.utf8Length,
                   kind: .init(swiftSyntaxTokenKind: token.tokenKind))
        return super.visit(token)
    }

    override public func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        typeDeclaration(node)
        return super.visit(node)
    }

    override public func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        typeDeclaration(node)
        return super.visit(node)
    }

    override public func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        typeDeclaration(node)
        return super.visit(node)
    }

    override public func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        typeDeclaration(node)
        return super.visit(node)
    }

    override public func visit(_ node: VariableDeclSyntax) -> DeclSyntax {
        if let firstToken = node.bindings.firstToken {
            updateDict(location: firstToken.positionAfterSkippingLeadingTrivia.utf8Offset,
                       length: firstToken.contentLength.utf8Length,
                       kind: .otherDeclaration)
        }
        return super.visit(node)
    }

    override public func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        updateDict(location: node.identifier.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.identifier.contentLength.utf8Length,
                   kind: .otherDeclaration)
        return super.visit(node)
    }

    override public func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        updateDict(location: node.calledExpression.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.calledExpression.contentLength.utf8Length,
                   kind: .functionCall)
        return super.visit(node)
    }

    override public func visit(_ node: SimpleTypeIdentifierSyntax) -> TypeSyntax {
        updateDict(location: node.name.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.name.contentLength.utf8Length,
                   kind: .typeUsed)
        return super.visit(node)
    }

    override public func visit(_ node: TupleExprElementSyntax) -> Syntax {
        if let label = node.label {
            updateDict(location: label.positionAfterSkippingLeadingTrivia.utf8Offset,
                       length: label.contentLength.utf8Length,
                       kind: .argument)
        }
        return super.visit(node)
    }

    override public func visit(_ node: DeclModifierSyntax) -> Syntax {
        updateDict(location: node.name.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.name.contentLength.utf8Length,
                   kind: .keyWord)
        return super.visit(node)
    }

    override public func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        if let base = node.base,
           let firstCharacter = base.description.unicodeScalars.first,
           CharacterSet.uppercaseLetters.contains(firstCharacter)
        {
            updateDict(location: base.positionAfterSkippingLeadingTrivia.utf8Offset,
                       length: base.contentLength.utf8Length,
                       kind: .typeUsed)
        }
        updateDict(location: node.name.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: node.name.contentLength.utf8Length,
                   kind: .member)
        return super.visit(node)
    }
}
