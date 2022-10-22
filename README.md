# HighlightSwiftSyntax

Outputs highlighted Swift Code as NSAttributedString using [apple/swift-syntax](https://github.com/apple/swift-syntax)

```swift
let inputCode = """
let inputCode: String
let rangeToKind: [NSRange: MyWordKind]

override public func visit(_ node: TupleExprElementSyntax) -> Syntax {
    if let label = node.label {
        updateDict(location: label.positionAfterSkippingLeadingTrivia.utf8Offset,
                   length: label.contentLength.utf8Length,
                   kind: .argument)
    }
    return super.visit(node)
}
"""

let output = try SwiftHighlighter().highlight(inputCode)
```
