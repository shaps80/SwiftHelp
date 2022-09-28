import SwiftUI
import SwiftUIBackports

public struct QuestionMarkHelpElementStyle: HelpElementStyle {
    private struct Modifier: ViewModifier {
        @Backport.ScaledMetric(wrappedValue: 2, relativeTo: .caption1) private var multiplier

        @Environment(\.help) private var help

        let alignment: Alignment
        let configuration: Configuration

        init(alignment: Alignment, configuration: Configuration) {
            self.alignment = alignment
            self.configuration = configuration
        }

        func body(content: Content) -> some View {
            content
                .backport.overlay(alignment: alignment) {
                    if (help.wrappedValue == nil && configuration.isVisible)
                        || configuration.isPresented {
                        Image(systemName: "questionmark")
                            .imageScale(.medium)
                            .font(.caption.weight(.bold))
                            .foregroundColor(.black)
                            .padding(3 * multiplier)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .contentShape(Rectangle().inset(by: -10))
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                            .saturation(configuration.isPresented ? 0 : 1)
                            .offset(x: horizontalOffset, y: verticalOffset)
                    }
                }
        }

        private var horizontalOffset: CGFloat {
            switch alignment.horizontal {
            case .leading: return -5 * multiplier
            case .trailing: return 5 * multiplier
            default: return 0
            }
        }

        private var verticalOffset: CGFloat {
            switch alignment.vertical {
            case .top: return -6 * multiplier
            case .bottom: return 6 * multiplier
            default: return 0
            }
        }
    }

    let alignment: Alignment

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(Modifier(alignment: alignment, configuration: configuration))
    }
}

public extension HelpElementStyle where Self == QuestionMarkHelpElementStyle {
    static var questionmark: Self { questionmark(alignment: .topTrailing) }
    static func questionmark(alignment: Alignment) -> Self { .init(alignment: alignment) }
}
