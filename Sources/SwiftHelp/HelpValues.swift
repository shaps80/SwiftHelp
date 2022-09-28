import SwiftUI

public struct HelpContent {
    public static subscript<H: Help>(_ keyPath: KeyPath<HelpContent, H>) -> H {
        HelpContent()[keyPath: keyPath]
    }
}
