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

let inputCode = """
/// My documentation comment
let inputCode: String
// line comment
override public func calculate(_ benefit: String) -> Universe {
    if let unwraplabel = chuck.label {
        updateAccount(location: unwraplabel.startingPoint.utf8Offset,
                   kind: .argument)
    let a = MyEnum.staticmethod()
    let b = AnotherEnum.nested.staticmethod()
    return
    }
    return super.visit(node)
}
"""

//let inputCode = """
//
//let nsrange = NSRange(location: 0, length: 0)
//struct OutputView: View {}
//super.visit(node)
//"""

//let inputCode = """
///// My documentation comment
//let inputCode: String
//let myNumber = 34.9
//// line comment
//override public func visit(_ label: String) -> Int {
//    print("Amazing!")
//    super.visit()
//}
//"""

let output = try SwiftHighlighter.init(inputCode: inputCode).highlight()

struct OutputView: View {
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.black)
            Text(AttributedString(output))
        }
    }
}

PlaygroundPage.current.setLiveView(OutputView())
