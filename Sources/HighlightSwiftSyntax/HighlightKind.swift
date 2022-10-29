//
// https://github.com/atacan
// 29.10.22

import SwiftSyntax

public enum HighlightKind {
    // swiftformat:sort
    // swiftformat:sort:begin
    /// function argument label when it is called
    case argument
    /// function input argument label for external callers
    case argumentLabel
    case codeComment
    case documentComment
    case functionCall
    case keyWord
    case member
    case numeric
    /// variable or constant names when they are first declared
    case otherDeclaration
    /// function input parameter name to be used in the function scope
    case parameterName
    case plainText
    case preprocessor
    /// xcode snippet placeholders
    case snippetPlaceholder
    case string
    case typeDeclaration
    case typeUsed
    case whiteSpace
    // swiftformat:sort:end

    static func convertSwiftSyntax(_ swiftSyntax: TokenSyntax) -> HighlightKind {
        switch swiftSyntax.tokenKind {

        case .eof:
            return .plainText
        case .associatedtypeKeyword:
            return .keyWord
        case .classKeyword:
            return .keyWord
        case .deinitKeyword:
            return .keyWord
        case .enumKeyword:
            return .keyWord
        case .extensionKeyword:
            return .keyWord
        case .funcKeyword:
            return .keyWord
        case .importKeyword:
            return .keyWord
        case .initKeyword:
            return .keyWord
        case .inoutKeyword:
            return .keyWord
        case .letKeyword:
            return .keyWord
        case .operatorKeyword:
            return .keyWord
        case .precedencegroupKeyword:
            return .keyWord
        case .protocolKeyword:
            return .keyWord
        case .structKeyword:
            return .keyWord
        case .subscriptKeyword:
            return .keyWord
        case .typealiasKeyword:
            return .keyWord
        case .varKeyword:
            return .keyWord
        case .fileprivateKeyword:
            return .keyWord
        case .internalKeyword:
            return .keyWord
        case .privateKeyword:
            return .keyWord
        case .publicKeyword:
            return .keyWord
        case .staticKeyword:
            return .keyWord
        case .deferKeyword:
            return .keyWord
        case .ifKeyword:
            return .keyWord
        case .guardKeyword:
            return .keyWord
        case .doKeyword:
            return .keyWord
        case .repeatKeyword:
            return .keyWord
        case .elseKeyword:
            return .keyWord
        case .forKeyword:
            return .keyWord
        case .inKeyword:
            return .keyWord
        case .whileKeyword:
            return .keyWord
        case .returnKeyword:
            return .keyWord
        case .breakKeyword:
            return .keyWord
        case .continueKeyword:
            return .keyWord
        case .fallthroughKeyword:
            return .keyWord
        case .switchKeyword:
            return .keyWord
        case .caseKeyword:
            return .keyWord
        case .defaultKeyword:
            return .keyWord
        case .whereKeyword:
            return .keyWord
        case .catchKeyword:
            return .keyWord
        case .throwKeyword:
            return .keyWord
        case .asKeyword:
            return .keyWord
        case .anyKeyword:
            return .keyWord
        case .falseKeyword:
            return .keyWord
        case .isKeyword:
            return .keyWord
        case .nilKeyword:
            return .keyWord
        case .rethrowsKeyword:
            return .keyWord
        case .superKeyword:
            return .keyWord
        case .selfKeyword:
            return .keyWord
        case .capitalSelfKeyword:
            return .keyWord
        case .trueKeyword:
            return .keyWord
        case .tryKeyword:
            return .keyWord
        case .throwsKeyword:
            return .keyWord
        case .__file__Keyword:
            return .keyWord
        case .__line__Keyword:
            return .keyWord
        case .__column__Keyword:
            return .keyWord
        case .__function__Keyword:
            return .keyWord
        case .__dso_handle__Keyword:
            return .keyWord
        case .wildcardKeyword:
            return .numeric
        case .leftParen:
            return .plainText
        case .rightParen:
            return .plainText
        case .leftBrace:
            return .plainText
        case .rightBrace:
            return .plainText
        case .leftSquareBracket:
            return .plainText
        case .rightSquareBracket:
            return .plainText
        case .leftAngle:
            return .plainText
        case .rightAngle:
            return .plainText
        case .period:
            return .plainText
        case .prefixPeriod: // TODO: Check
            return .plainText
        case .comma:
            return .plainText
        case .ellipsis:
            return .plainText
        case .colon:
            return .plainText
        case .semicolon:
            return .plainText
        case .equal:
            return .plainText
        case .atSign:
            return .plainText
        case .pound: // TODO: Check
            return .plainText
        case .prefixAmpersand: // TODO: Check
            return .plainText
        case .arrow:
            return .plainText
        case .backtick:
            return .plainText
        case .backslash:
            return .plainText
        case .exclamationMark:
            return .keyWord
        case .postfixQuestionMark:
            return .keyWord
        case .infixQuestionMark:
            return .keyWord
        case .stringQuote:
            return .string
        case .singleQuote: // TODO: Check
            return .plainText
        case .multilineStringQuote:
            return .string
        case .poundKeyPathKeyword:
            return .keyWord
        case .poundLineKeyword:
            return .keyWord
        case .poundSelectorKeyword:
            return .keyWord
        case .poundFileKeyword:
            return .keyWord
        case .poundFileIDKeyword:
            return .keyWord
        case .poundFilePathKeyword:
            return .keyWord
        case .poundColumnKeyword:
            return .keyWord
        case .poundFunctionKeyword:
            return .keyWord
        case .poundDsohandleKeyword:
            return .keyWord
        case .poundAssertKeyword:
            return .keyWord
        case .poundSourceLocationKeyword:
            return .keyWord
        case .poundWarningKeyword:
            return .keyWord
        case .poundErrorKeyword:
            return .keyWord
        case .poundIfKeyword:
            return .preprocessor
        case .poundElseKeyword:
            return .preprocessor
        case .poundElseifKeyword:
            return .preprocessor
        case .poundEndifKeyword:
            return .preprocessor
        case .poundAvailableKeyword:
            return .keyWord
        case .poundUnavailableKeyword:
            return .keyWord
        case .poundFileLiteralKeyword:
            return .keyWord
        case .poundImageLiteralKeyword:
            return .keyWord
        case .poundColorLiteralKeyword:
            return .keyWord
        case .integerLiteral:
            return .numeric
        case .floatingLiteral:
            return .numeric
        case .stringLiteral:
            return .string
        case .regexLiteral:
            return .string
        case .unknown:
            return .plainText
        case .identifier: // TODO: check previous token
            return identifierKind(swiftSyntax)
        case .unspacedBinaryOperator:
            return .plainText
        case .spacedBinaryOperator:
            return .plainText
        case .postfixOperator: // TODO: check
            return .plainText
        case .prefixOperator: // TODO: check
            return .plainText
        case .dollarIdentifier: // TODO: check next token
            return .plainText
        case .contextualKeyword: // TODO: check
            return .plainText
        case .rawStringDelimiter:
            return .string
        case .stringSegment:
            return .string
        case .stringInterpolationAnchor:
            return .plainText
        case .yield:
            return .keyWord
        }
    }

    static func identifierKind(_ swiftSyntax: TokenSyntax?) -> HighlightKind {
        guard let swiftSyntax else { return .plainText }

        switch swiftSyntax.tokenClassification.kind {

//        case .none:
        case .keyword:
            return .keyWord
//        case .identifier:
        case .typeIdentifier:
            return .typeUsed
//        case .dollarIdentifier:
        case .integerLiteral:
            return .numeric
        case .floatingLiteral:
            return .numeric
        case .stringLiteral:
            return .string
        case .stringInterpolationAnchor:
            return .plainText
        case .poundDirectiveKeyword:
            return .keyWord
        case .buildConfigId:
            return .preprocessor
        case .attribute:
            return .keyWord
        case .objectLiteral:
            return .plainText
        case .editorPlaceholder:
            return .snippetPlaceholder
        case .lineComment:
            return .codeComment
        case .docLineComment:
            return .documentComment
        case .blockComment:
            return .codeComment
        case .docBlockComment:
            return .documentComment
        default:
            break
        }

        guard let previous = swiftSyntax.previousToken else { return .plainText }

        switch previous.tokenKind {
        case .classKeyword, .enumKeyword, .protocolKeyword, .structKeyword:
            return .typeDeclaration
        case .funcKeyword, .letKeyword, .varKeyword:
            return .otherDeclaration
        default:
            return .plainText
        }
    }

    static func convertTriviaPiece(_ piece: TriviaPiece) -> (HighlightKind, String) {
        switch piece {
        case let .spaces(count):
            return (.plainText, String(repeating: " ", count: count))
        case let .tabs(count):
            return (.plainText, String(repeating: "\t", count: count))
        case let .verticalTabs(count):
            return (.plainText, String(repeating: "\u{11}", count: count))
        case let .formfeeds(count):
            return (.plainText, String(repeating: "\u{12}", count: count))
        case let .newlines(count):
            return (.plainText, String(repeating: "\n", count: count))
        case let .carriageReturns(count):
            return (.plainText, String(repeating: "\r", count: count))
        case let .carriageReturnLineFeeds(count):
            return (.plainText, String(repeating: "\r\n", count: count))
        case let .lineComment(text):
            return (.codeComment, text)
        case let .blockComment(text):
            return (.codeComment, text)
        case let .docLineComment(text):
            return (.documentComment, text)
        case let .docBlockComment(text):
            return (.documentComment, text)
        case let .garbageText(text):
            return (.plainText, text)
        }
    }

    init(swiftSyntax: TokenSyntax) {
        self = HighlightKind.convertSwiftSyntax(swiftSyntax)
    }
}
