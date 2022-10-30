import Cocoa
import HighlightSwiftSyntax
import PlaygroundSupport
import SwiftSyntax
import SwiftSyntaxParser
import SwiftUI
import WebKit
import Prelude

func printThis<A>(_ a: A){ print(a) }

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
let html = try SwiftHighlighter.init(inputCode: inputCode).html()
let style = SwiftHighlighter.init(inputCode: inputCode).styleCss()
html |> printThis
style |> printThis

NSColor(red: 0.942109, green: 0, blue: 0.630242, alpha: 1)
NSColor(red: CGFloat(66) / 255, green: CGFloat(142) / 255, blue: CGFloat(215) / 255, alpha: 1)
(0.942109 * 255) |> Int.init
(0 * 255)
(0.630242 * 255) |> Int.init

extension NSColor {

    var hexString: String {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return "FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }

}

NSColor(red: 0.942109, green: 0, blue: 0.630242, alpha: 1).hexString


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

