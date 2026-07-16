import SwiftUI

/// A tappable wrapper that applies the standard press animation to arbitrary content.
///
/// ```swift
/// CustomContentButton(action: select) {
///   RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 80, height: 36)
/// }
///
/// // Fixed-point growth instead of proportional, matching IconButton/TextButton:
/// CustomContentButton(action: select, pressExpansion: CustomButtonConfiguration.defaultPressExpansion) {
///   Text("Uniform").frame(maxWidth: .infinity, maxHeight: .infinity)
/// }
/// ```
public struct CustomContentButton<Content: View>: View {

  // MARK: Properties

  private let action: () -> Void
  private let pressExpansion: CGFloat?
  private let content: Content

  // MARK: Initialization

  /// - Parameters:
  ///   - action: Called on tap.
  ///   - pressExpansion: Fixed-point background growth in each direction. `nil`
  ///     (the default) uses the proportional scale — the right choice when
  ///     `content`'s size isn't known ahead of time. Pass a value for
  ///     layout-sized content that should grow like `IconButton`/`TextButton`.
  ///   - content: The wrapped content.
  public init(
    action: @escaping () -> Void,
    pressExpansion: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.action = action
    self.pressExpansion = pressExpansion
    self.content = content()
  }

  // MARK: Body

  public var body: some View {
    Button(action: action) {
      content
        .contentShape(Rectangle())
    }
    .buttonStyle(CustomButtonPressStyle(pressExpansion: pressExpansion))
  }
}

// MARK: Preview

#Preview("Content Button") {
  CustomContentButton(
    action: {},
    content: {
      RoundedRectangle(cornerRadius: 8)
        .fill(.teal)
        .frame(width: 120, height: 44)
        .overlay(Text("Press me").foregroundStyle(.white))
    }
  )
  .padding()
}

#Preview("Content Button — Fixed Expansion") {
  CustomContentButton(
    action: {},
    pressExpansion: CustomButtonConfiguration.defaultPressExpansion,
    content: {
      RoundedRectangle(cornerRadius: 8)
        .fill(.teal)
        .frame(width: 120, height: 44)
        .overlay(Text("Press me").foregroundStyle(.white))
    }
  )
  .padding()
}
