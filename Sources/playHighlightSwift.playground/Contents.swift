import Cocoa
import HighlightSwiftSyntax
import PlaygroundSupport
import SwiftSyntax
import SwiftSyntaxParser
import SwiftUI
import WebKit

var greeting = "Hello, playground"
let mainString = "Hello World"
let stringToColor = "World"
let range = (mainString as NSString).range(of: stringToColor)
// print(range)
// print(NSRange(location: 5, length: 6))

//let inputCode = """
///// My documentation comment
//let inputCode: String
//// line comment
//override public func calculate(_ benefit: String, for group: Browser, goal: Int = 12) -> Universe {
//fetch(data: Int)
// return Universe()
//}
//"""

//let inputCode = """
//
//let nsrange = NSRange(location: 0, length: 0)
//struct OutputView: View {}
//super.visit(node)
//node.identifier.positionAfterSkippingLeadingTrivia.utf8Offset()
//"""

let inputCode = """
struct Amazement {}
/// My documentation comment
let inputCode: String
let myNumber = 34.9
// line comment
override public func visit(_ label: String) -> Int {
print("Amazing!")
    super.visit()
}
"""

let output = try SwiftHighlighter.init(inputCode: inputCode).highlight()

struct OutputView: View {
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.black)
            Text(AttributedString(output))
                .padding()
        }
    }
}

PlaygroundPage.current.setLiveView(OutputView())
