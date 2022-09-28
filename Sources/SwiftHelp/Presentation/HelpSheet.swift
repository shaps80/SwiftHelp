import SwiftUI

extension View {
    func help<H: Help>(_ keyPath: KeyPath<HelpValues, H>) -> some View {
        modifier(HelpSheetModifier(help: HelpValues()[keyPath: keyPath]))
    }
}

private struct HelpSheetModifier<H: Help>: ViewModifier {
    @Environment(\.helpVisibility) private var visibility
    @Environment(\.helpElementStyle) private var style
    @Environment(\.help) private var selection

    let help: H
    func body(content: Content) -> some View {
        if visibility != .hidden {
            Button {
                selection.wrappedValue = .init(help)
            } label: {
                style.makeBody(configuration: .init(
                    help: help,
                    label: content
                ))
            }
            .buttonStyle(.plain)
        } else {
            content
        }
    }
}
