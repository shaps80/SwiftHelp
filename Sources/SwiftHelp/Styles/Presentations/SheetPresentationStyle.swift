import SwiftUI
import SwiftUIBackports

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
