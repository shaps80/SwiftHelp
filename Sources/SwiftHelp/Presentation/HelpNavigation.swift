import SwiftUI

extension NavigationLink where Label == Text, Destination == AnyView {
    public init<S: StringProtocol, H: Help>(_ title: S, help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent()[keyPath: keyPath]
        self.init(title) {
            AnyView(
                HelpNavigationView(help: help)
                    .helpPresentationStyle(.plain)
            )
        }
    }

    public init<H: Help>(_ titleKey: LocalizedStringKey, help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent()[keyPath: keyPath]
        self.init(titleKey) {
            AnyView(
                HelpNavigationView(help: help)
                    .helpPresentationStyle(.plain)
            )
        }
    }
}

extension NavigationLink where Destination == AnyView {
    public init<H: Help>(help keyPath: KeyPath<HelpContent, H>, @ViewBuilder label: () -> Label) {
        let help = HelpContent()[keyPath: keyPath]
        self.init {
            AnyView(
                HelpNavigationView(help: help)
                    .helpPresentationStyle(.plain)
            )
        } label: {
            label()
        }
    }
}

extension NavigationLink where Label == Text, Destination == AnyView {
    public init<H: Help>(help keyPath: KeyPath<HelpContent, H>) {
        let help = HelpContent()[keyPath: keyPath]
        self.init {
            AnyView(
                HelpNavigationView(help: help)
                    .helpPresentationStyle(.plain)
            )
        } label: {
            Text(help.title)
        }
    }
}

private struct HelpNavigationView<H: Help>: View {
    @Environment(\.helpPresentationStyle) private var style
    let help: H
    var body: some View {
        style.makeBody(configuration: .init(
            help: help,
            label: help.body
        ))
    }
}
