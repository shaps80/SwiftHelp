import SwiftUI

internal struct HelpMode {
    var isVisible: Bool { _isVisible.wrappedValue }
    var _isVisible: Binding<Bool>

    mutating func dismiss() {
        _isVisible.wrappedValue = false
    }
}

public struct DismissHelpAction {
    var mode: Binding<HelpMode>
    public func callAsFunction() {
        mode.wrappedValue.dismiss()
    }
}

private struct HelpModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<HelpMode>
    = .constant(.init(_isVisible: .constant(false)))
}

internal extension EnvironmentValues {
    var helpMode: Binding<HelpMode> {
        get { self[HelpModeEnvironmentKey.self] }
        set { self[HelpModeEnvironmentKey.self] = newValue }
    }

    var isHelpVisible: Bool {
        helpMode.wrappedValue.isVisible
    }
}

public extension EnvironmentValues {
    var dismissHelp: DismissHelpAction {
        .init(mode: helpMode)
    }
}
