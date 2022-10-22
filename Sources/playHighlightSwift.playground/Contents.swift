import Cocoa
import HighlightSwiftSyntax
import PlaygroundSupport
import SwiftSyntax
import SwiftSyntaxParser
import SwiftUI



var greeting = "Hello, playground"
let mainString = "Hello World"
let stringToColor = "World"
let range = (mainString as NSString).range(of: stringToColor)
// print(range)
// print(NSRange(location: 5, length: 6))

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

let rewriter = SwiftHighlighterRewriter()
let inputSource = try SyntaxParser.parse(source: inputCode)
_ = rewriter.visit(inputSource)

//dump(rewriter.debugDict)
//dump(rewriter.parsedCode)

let colorizer = Colorizer(inputCode: inputCode, rangeToKind: rewriter.parsedCode.rangeToKind)

PlaygroundPage.current.setLiveView(
    ZStack {
        Rectangle().foregroundColor(Color(nsColor: .textBackgroundColor))
        Text(AttributedString(colorizer.highlightedCode()))
            .font(.monospaced(.body)())
            .font(.title)
    }
)
//PlaygroundPage.current.setLiveView(Rectangle()
////    .foregroundColor(Color(nsColor: NSColor(deviceRed: 0.942109, green: 0 , blue: 0.630242, alpha: 1)))
////    .foregroundColor(Color(nsColor: NSColor(red: 0.942109, green: 0 , blue: 0.630242, alpha: 1)))
//    .foregroundColor(Color(nsColor: NSColor(red: CGFloat(66) / 255, green: CGFloat(142) / 255 , blue: CGFloat(215) / 255, alpha: 1)))
//    .frame(width: 40, height: 40)
//)
