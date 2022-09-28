import SwiftUI

public protocol HelpKey {
    associatedtype Body: Help
    static var help: Body { get }
}

public struct HelpValues {
    public init() { }
    public subscript<K: HelpKey>(key: K.Type) -> some Help { K.help }
}
