import SwiftUI

public extension View {
    func help<H: Help>(_ keyPath: KeyPath<HelpContent, H>) -> some View {
        modifier(HelpSheetModifier(help: HelpContent()[keyPath: keyPath]))
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
            selection.wrappedValue = .init(help)
        } label: {
            style.makeBody(configuration: .init(
                help: .init(help),
                label: .init(content),
                isVisible: isVisible,
                isPresented: selection.wrappedValue?.id == help.id
            ))
        }
        .buttonStyle(.plain)
    }
}
