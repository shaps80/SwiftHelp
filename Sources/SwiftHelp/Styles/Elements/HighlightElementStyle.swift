import SwiftUI
import SwiftUIBackports

public struct HighlightHelpElementStyle: HelpElementStyle {
    private struct Modifier: ViewModifier {
        @Environment(\.help) private var help

        let color: Color
        let radius: CGFloat
        let lineWidth: CGFloat
        let configuration: Configuration

        func body(content: Content) -> some View {
            content
                .scaleEffect(x: configuration.isVisible ? 0.98 : 1, y: configuration.isVisible ? 0.95 : 1)
                .allowsHitTesting(!configuration.isVisible)
                .backport.overlay {
                    if (help.wrappedValue == nil && configuration.isVisible)
                        || configuration.isPresented {
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .inset(by: -lineWidth / 2)
                            .stroke(.yellow, lineWidth: lineWidth)
                            .saturation(configuration.isPresented ? 0 : 1)
                            .opacity(configuration.isPresented ? 0.3 : 1)
                            .contentShape(Rectangle())
                    }
                }
        }
    }

    let color: Color
    let radius: CGFloat
    let lineWidth: CGFloat

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(Modifier(color: color, radius: radius, lineWidth: lineWidth, configuration: configuration))
    }
}

extension HighlightHelpElementStyle {
    public init() { self.init(color: .yellow, radius: 5, lineWidth: 2) }
}

public extension HelpElementStyle where Self == HighlightHelpElementStyle {
    static var highlight: Self { .init() }
    static func highlight(color: Color, radius: CGFloat = 5, lineWidth: CGFloat = 2) -> Self {
        .init(color: color, radius: radius, lineWidth: lineWidth)
    }
}
