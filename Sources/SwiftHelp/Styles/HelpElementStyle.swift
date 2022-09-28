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

    init<H: Help, Label: View>(help: H, label: Label) {
        self.help = .init(help)
        self.label = .init(label)
    }

    init<H: Help, Label: View>(help: H, @ViewBuilder label: () -> Label) {
        self.help = .init(help)
        self.label = .init(label())
    }
}

public struct DefaultHelpElementStyle: HelpElementStyle {
    public init() { }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .backport.overlay {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(Color.yellow, lineWidth: 2)
            }
    }
}

public extension HelpElementStyle where Self == DefaultHelpElementStyle {
    static var `default`: Self { .init() }
}

private struct HelpElementStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = AnyHelpElementStyle(.default)
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
