import SwiftUI
import SwiftUIBackports

public struct QuestionMarkHelpElementStyle: HelpElementStyle {
    private struct Modifier: ViewModifier {
        @Environment(\.help) private var help
        let alignment: Alignment
        let color: Color
        let configuration: Configuration

        func body(content: Content) -> some View {
            content
                .backport.overlay(alignment: alignment) {
                    if (help.wrappedValue == nil && configuration.isVisible)
                        || configuration.isPresented {
                        Image(systemName: "questionmark")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .contentShape(Rectangle().inset(by: -10))
                            .transition(.scale.combined(with: .opacity))
                            .saturation(configuration.isPresented ? 0 : 1)
                    }
                }
        }
    }

    let alignment: Alignment
    let color: Color

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(Modifier(alignment: alignment, color: color, configuration: configuration))
    }
}

public extension HelpElementStyle where Self == QuestionMarkHelpElementStyle {
    static var questionmark: Self { questionmark(color: .yellow) }
    static func questionmark(alignment: Alignment = .topTrailing, color: Color) -> Self { .init(alignment: alignment, color: color) }
}
