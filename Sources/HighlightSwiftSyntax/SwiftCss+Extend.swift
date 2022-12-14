//
// https://github.com/atacan
// 01.11.22

import SwiftCss

func Elements(_ names: [any Stylable], separator: String, @PropertyBuilder _ builder: () -> [Property]) -> SwiftCss.Selector {
    Selector(names.map(\.selector).joined(separator: separator), builder)
}

/// ``Elements(inside: [.div, .p])``
/// Selects all `<p>` elements inside `<div> `elements: `div p`
func Elements(inside: [any Stylable], @PropertyBuilder _ builder: () -> [Property]) -> SwiftCss.Selector {
    Elements(inside, separator: " ", builder)
}

/// ``Elements(parental: [.div, .p])``
/// Selects all `<p>` elements where the parent is a `<div>` element: `div > p`
func Elements(parental: [any Stylable], @PropertyBuilder _ builder: () -> [Property]) -> SwiftCss.Selector {
    Elements(parental, separator: " > ", builder)
}

func Element(_ element: any Stylable, ofClass: any Stylable) -> [Stylable] {
    [element, ofClass]
}

protocol Stylable {
    var selector: String { get }
}

extension HTMLElement: Stylable {
    var selector: String {
        rawValue
    }
}

extension HighlightKind: Stylable {
    var selector: String {
        ".\(cssClass(kind: self))"
    }
}

extension [Stylable]: Stylable{
    var selector: String {
        self.map(\.selector).joined(separator: ".")
    }
}
