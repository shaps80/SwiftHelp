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

    init<H: Help, Label: View>(help: H, label: Label) {
        self.help = .init(help)
        self.label = .init(label)
    }

    init<H: Help, Label: View>(help: H, @ViewBuilder label: () -> Label) {
        self.help = .init(help)
        self.label = .init(label())
    }
}

public struct SheetHelpPresentationStyle: HelpPresentationStyle {
    struct Label: View {
        @State private var show: Bool = false
        @Environment(\.backportDismiss) private var dismiss

        let help: AnyHelp
        let content: AnyView

        var body: some View {
            NavigationView {
                help.body
                    .backport.navigationTitle(help.title)
                    .backport.toolbar {
                        Button {
                            dismiss()
                        } label: {
                            Text("Close")
                        }
                    }
            }
            .modifier(PresentationModifier())
        }
    }

    public init() { }
    public func makeBody(configuration: Configuration) -> some View {
        Label(help: configuration.help, content: configuration.label)
    }
}

struct PresentationModifier: ViewModifier {
    func body(content: Content) -> some View {
#if os(iOS)
        if #available(iOS 15, *) {
            content
                .backport.presentationDragIndicator(.visible)
                .backport.presentationDetents([.medium, .large], selection: .constant(.medium), largestUndimmedDetent: nil)
        } else {
            content
        }
#else
        content
#endif
    }
}

public extension HelpPresentationStyle where Self == SheetHelpPresentationStyle {
    static var sheet: Self { .init() }
}

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
