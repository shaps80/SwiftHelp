import SwiftUI
import SwiftUIBackports

extension NavigationLink where Label == Text, Destination == AnyView {
    public init<S: StringProtocol, H: Help>(_ title: S, help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent[keyPath]
        self.init(title) {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        }
    }

    public init<H: Help>(_ titleKey: LocalizedStringKey, help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent[keyPath]
        self.init(titleKey) {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        }
    }

    public init<S: StringProtocol, H: Help>(_ title: S, help: H) {
        self.init(title) {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        }
    }

    public init<H: Help>(_ titleKey: LocalizedStringKey, help: H) {
        self.init(titleKey) {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        }
    }
}

extension NavigationLink where Destination == AnyView {
    public init<H: Help>(help keyPath: KeyPath<HelpContent, H>, @ViewBuilder label: () -> Label) {
        let help = HelpContent[keyPath]
        self.init {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        } label: {
            label()
        }
    }

    public init<H: Help>(help: H, @ViewBuilder label: () -> Label) {
        self.init {
            AnyView(
                HelpNavigationView(help: .init(help))
                    .helpPresentationStyle(.plain)
            )
        } label: {
            label()
        }
    }
}

extension NavigationLink where Label == Text, Destination == AnyView {
    public init<H: Help>(help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent[keyPath]
        self.init {
            AnyView(HelpNavigationView(help: .init(help)))
        } label: {
            Text(help.title)
        }
    }

    public init<H: Help>(help: H) {
        self.init {
            AnyView(HelpNavigationView(help: .init(help)))
        } label: {
            Text(help.title)
        }
    }
}

private struct HelpNavigationView: View {
    @Environment(\.helpPresentationStyle) private var style
    let help: AnyHelp
    var body: some View {
        style.makeBody(configuration: .init(
            help: help,
            label: help.body
        ))
    }
}
