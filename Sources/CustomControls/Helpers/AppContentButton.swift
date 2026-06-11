import SwiftUI

/// A tappable wrapper that applies the standard press animation to arbitrary content.
///
/// `AppIndicatorButton` is for color swatches; `AppContentButton` is the general
/// case — the caller supplies the full visual, and this adds only the tap target
/// and `ButtonPressStyle`, so the press feel matches every other button.
///
/// ```swift
/// AppContentButton(action: select) {
///   RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 80, height: 36)
/// }
/// ```
public struct AppContentButton<Content: View>: View {

  // MARK: Properties

  private let action: () -> Void
  private let content: Content

  // MARK: Initialization

  public init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
    self.action = action
    self.content = content()
  }

  // MARK: Body

  public var body: some View {
    Button(action: action) {
      content
        .contentShape(Rectangle())
    }
    .buttonStyle(ButtonPressStyle())
  }
}

// MARK: Preview

#Preview("App Content Button") {
  AppContentButton(
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
