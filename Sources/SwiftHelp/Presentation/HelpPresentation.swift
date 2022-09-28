import SwiftUI
import SwiftUIBackports

public extension View {
    func help(isVisible: Binding<Bool>) -> some View {
        modifier(HelpVisibilityModifier(isVisible: isVisible))
    }
}

private struct HelpVisibilityModifier: ViewModifier {
    @Environment(\.helpPresentationStyle) private var presentation
    @State private var help: AnyHelp?
    @Binding var isVisible: Bool

    func body(content: Content) -> some View {
        content
            .sheet(item: $help.animation()) { help in
                presentation.makeBody(configuration: .init(help: help, label: help.body))
            }
            .environment(\.helpMode, .init(
                get: { .init(_isVisible: $isVisible )},
                set: { isVisible = $0.isVisible })
            )
            .environment(\.help, $help.animation())
    }
}
