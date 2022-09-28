import SwiftUI

public protocol Help: View, Identifiable where ID == String {
    var title: String { get }
}

public struct AnyHelp: Help {
    public var id: String
    public var title: String
    public var body: AnyView

    public init<H: Help>(_ help: H) {
        self.id = help.id
        self.title = help.title
        self.body = .init(help.body)
    }
}

private struct HelpEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<AnyHelp?> = .constant(nil)
}

internal extension EnvironmentValues {
    var help: Binding<AnyHelp?> {
        get { self[HelpEnvironmentKey.self] }
        set { self[HelpEnvironmentKey.self] = newValue }
    }
}
