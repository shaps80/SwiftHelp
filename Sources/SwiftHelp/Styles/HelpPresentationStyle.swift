import SwiftUI
import SwiftUIBackports

public protocol HelpPresentationStyle {
    associatedtype Body: View
    typealias Configuration = HelpPresentationConfiguration
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

public struct AnyHelpPresentationStyle: HelpPresentationStyle {
    var label: (Configuration) -> AnyView
    init<S: HelpPresentationStyle>(_ style: S) {
        label = { AnyView(style.makeBody(configuration: $0)) }
    }

    public func makeBody(configuration: Configuration) -> some View {
        label(configuration)
    }
}

public struct HelpPresentationConfiguration {
    public let help: AnyHelp
    public let label: AnyView
}

private struct HelpPresentationStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = AnyHelpPresentationStyle(.sheet)
}

public extension EnvironmentValues {
    var helpPresentationStyle: AnyHelpPresentationStyle {
        get { self[HelpPresentationStyleEnvironmentKey.self] }
        set { self[HelpPresentationStyleEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func helpPresentationStyle<S: HelpPresentationStyle>(_ style: S) -> some View {
        environment(\.helpPresentationStyle, AnyHelpPresentationStyle(style))
    }
}
