import SwiftUI
import SwiftUIBackports

public protocol HelpElementStyle {
    associatedtype Body: View
    typealias Configuration = HelpElementConfiguration
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

public struct AnyHelpElementStyle: HelpElementStyle {
    var label: (Configuration) -> AnyView
    init<S: HelpElementStyle>(_ style: S) {
        label = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: Configuration) -> some View {
        label(configuration)
    }
}

public struct HelpElementConfiguration {
    public var help: AnyHelp
    public var label: AnyView
    public var isVisible: Bool
    public var isPresented: Bool
}

private struct HelpElementStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = AnyHelpElementStyle(.highlight)
}

public extension EnvironmentValues {
    var helpElementStyle: AnyHelpElementStyle {
        get { self[HelpElementStyleEnvironmentKey.self] }
        set { self[HelpElementStyleEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func helpElementStyle<S: HelpElementStyle>(_ style: S) -> some View {
        environment(\.helpElementStyle, AnyHelpElementStyle(style))
    }
}
