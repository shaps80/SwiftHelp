import SwiftUI
import SwiftUIBackports

extension View {
    func help(_ visibility: Backport<Any>.Visibility) -> some View {
        modifier(HelpVisibilityModifier(visibility: visibility))
    }
}

private struct HelpVisibilityModifier: ViewModifier {
    @Environment(\.helpPresentationStyle) private var presentation
    @State private var help: AnyHelp?
    var visibility: Backport<Any>.Visibility

    func body(content: Content) -> some View {
        content
            .environment(\.help, $help)
            .environment(\.helpVisibility, visibility)
            .sheet(item: $help) { help in
                presentation.makeBody(configuration: .init(help: help, label: help.body))
            }
    }
}

private struct HelpVisibilityEnvironmentKey: EnvironmentKey {
    static var defaultValue: Backport<Any>.Visibility = .hidden
}

public extension EnvironmentValues {
    var helpVisibility: Backport<Any>.Visibility {
        get { self[HelpVisibilityEnvironmentKey.self] }
        set { self[HelpVisibilityEnvironmentKey.self] = newValue }
    }
}
