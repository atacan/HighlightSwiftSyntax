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

let output = try SwiftHighlighter.highlight(inputCode)
```
<img width="885" alt="Screenshot 2022-10-22 at 18 02 05" src="https://user-images.githubusercontent.com/765873/197349249-d7bc0770-9426-4d21-b55c-25874f572cad.png">

## Theme
Currently it uses the theme from https://github.com/atacan/Amaze-Midnight.    
Custom theme functionality is coming soon...
