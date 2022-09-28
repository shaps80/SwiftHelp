import SwiftUI
import SwiftUIBackports

extension Backport where Wrapped: View {
    @ViewBuilder
    func toolbar<Content: View>(@ViewBuilder content c: () -> Content) -> some View {
        #if os(iOS)
        if #available(iOS 14, *) {
            content.toolbar(content: c)
        } else {
            content.navigationBarItems(trailing: c())
        }
        #else
        if #available(macOS 11, *) {
            content.toolbar(content: c)
        } else {
            content
        }
        #endif
    }
}
