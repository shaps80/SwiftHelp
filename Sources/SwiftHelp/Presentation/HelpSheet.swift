import SwiftUI

public extension View {
    func help<H: Help>(_ keyPath: KeyPath<HelpContent, H>) -> some View {
        modifier(HelpSheetModifier(help: HelpContent[keyPath]))
    }

    func help<H: Help>(_ help: H) -> some View {
        modifier(HelpSheetModifier(help: help))
    }
}

private struct HelpSheetModifier<H: Help>: ViewModifier {
    @Environment(\.isHelpVisible) private var isVisible
    @Environment(\.helpElementStyle) private var style
    @Environment(\.help) private var selection

    let help: H
    func body(content: Content) -> some View {
        Button {
            if isVisible {
                selection.wrappedValue = .init(help)
            }
        } label: {
            style.makeBody(configuration: .init(
                help: .init(help),
                label: .init(content),
                isVisible: isVisible,
                isPresented: selection.wrappedValue?.id == help.id
            ))
        }
        .buttonConfiguration(isVisible: isVisible)
    }
}

private extension View {
    @ViewBuilder
    func buttonConfiguration(isVisible: Bool) -> some View {
        if isVisible {
            buttonStyle(.plain)
        } else {
            buttonStyle(NoButtonStyle())
        }
    }
}

private struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
