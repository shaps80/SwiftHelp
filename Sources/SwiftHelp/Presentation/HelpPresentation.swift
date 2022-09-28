import SwiftUI
import SwiftUIBackports

public extension View {
    func help(isVisible: Bool) -> some View {
        modifier(HelpVisibilityModifier(isVisible: isVisible))
    }
}

private struct HelpVisibilityModifier: ViewModifier {
    @Environment(\.helpPresentationStyle) private var presentation
    @State private var help: AnyHelp?
    var isVisible: Bool

    func body(content: Content) -> some View {
        content
            .sheet(item: $help.animation()) { help in
                presentation.makeBody(configuration: .init(help: help, label: help.body))
            }
            .environment(\.isHelpVisible, isVisible)
            .environment(\.help, $help.animation())
    }
}

private struct HelpPresentedEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var isHelpVisible: Bool {
        get { self[HelpPresentedEnvironmentKey.self] }
        set { self[HelpPresentedEnvironmentKey.self] = newValue }
    }
}
