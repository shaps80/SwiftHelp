import SwiftUI
import SwiftUIBackports

public struct PlainHelpPresentationStyle: HelpPresentationStyle {
    public init() { }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .backport.navigationTitle(configuration.help.title)
    }
}

public extension HelpPresentationStyle where Self == PlainHelpPresentationStyle {
    static var plain: Self { .init() }
}
