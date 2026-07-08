import SwiftUI

/// A button combining an icon and a text label at a fixed size, positioned
/// and colored via the environment — same pattern as `IconButton`.
///
/// `title` defaults to the icon's own `accessibilityLabel` (e.g. `.done` reads
/// "Done"), so the common case needs no text at all:
///
/// ```swift
/// TextButton(icon: .done, action: { })                    // shows "Done"
/// TextButton("Confirm", icon: .done, action: { })          // override
/// TextButton(icon: .cancel, action: { }).iconTrailing()
/// ```
///
/// ### Environment
///
/// - `.buttonSize(_:)` — height, shared with `IconButton`.
/// - `.buttonWidth(_:)` — fixed width. No intrinsic sizing.
/// - `.iconTrailing(_:)` — icon after the text instead of before. Leading by default.
/// - `.contentAlignment(_:)` — where the icon+text group sits inside the
///   button's width when it doesn't fill it (e.g. a wide button with a short
///   label). `.center` by default; `.leading`/`.trailing` push the group
///   toward that edge.
/// - `.iconColor(_:)` / `.iconBackground(_:)` — shared with `IconButton`; the
///   text uses the same resolved foreground as the icon.
/// - `.buttonPressExpansion(_:)` — same fixed-value background growth as
///   `IconButton`, applied independently in each dimension since this
///   button's width and height usually differ.
///
/// Press feedback is weight-only: icon and text both step up
/// `CustomButtonConfiguration.pressedWeightSteps` weights while pressed.
/// Unlike `IconButton`, nothing scales — scaling text tends to blur or
/// re-layout mid-animation, so the pop here is entirely a weight change.
public struct TextButton: View {

  // MARK: Properties

  private let title: String
  private let symbolName: String?
  private let style: CustomButtonStyle
  private let isDisabled: Bool
  private let action: () -> Void

  @State private var isPressed = false
  @State private var isAnimating = false

  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.buttonSize) private var buttonSize
  @Environment(\.buttonWidth) private var width
  @Environment(\.buttonPressExpansion) private var pressExpansion
  @Environment(\.iconColorOverride) private var iconColorOverride
  @Environment(\.iconBackgroundOverride) private var iconBackgroundOverride
  @Environment(\.textButtonIconTrailing) private var iconTrailing
  @Environment(\.textButtonContentAlignment) private var contentAlignment
  @Environment(\.textButtonContentSpacing) private var contentSpacing
  @Environment(\.textButtonContentPadding) private var contentPadding
  @Environment(\.textButtonFontSizeOverride) private var fontSizeOverride

  // MARK: Initialization

  /// Creates a Text Button from a built-in `IconType`. Kept as a concrete
  /// overload so leading-dot cases (`.undo`, `.done`) continue to resolve.
  ///
  /// - Parameter title: Text to display. Defaults to `icon.accessibilityLabel`
  ///   (e.g. `.done` reads "Done") — pass an explicit value to override it.
  public init(
    _ title: String? = nil,
    icon: IconType,
    style: CustomButtonStyle = .square,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(title: title, symbol: icon, style: style, isDisabled: isDisabled, action: action)
  }

  /// Creates a Text Button from any symbol identity.
  ///
  /// - Parameter title: Text to display. Defaults to `icon.accessibilityLabel`
  ///   — pass an explicit value to override it.
  public init(
    _ title: String? = nil,
    icon: some IconRepresentable,
    style: CustomButtonStyle = .square,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(title: title, symbol: icon, style: style, isDisabled: isDisabled, action: action)
  }

  /// Shared designated initializer.
  private init(
    title: String?,
    symbol: some IconRepresentable,
    style: CustomButtonStyle,
    isDisabled: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title ?? symbol.accessibilityLabel
    self.symbolName = symbol.symbolName
    self.style = style
    self.isDisabled = isDisabled
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    let resolvedDisabled = isDisabled || !isEnabled
    let resolvedForeground = theme.colors.resolvedForeground(override: iconColorOverride, disabled: resolvedDisabled)
    let resolvedBackground = theme.colors.resolvedBackground(override: iconBackgroundOverride, disabled: resolvedDisabled)

    Button(action: action, label: { content(foreground: resolvedForeground, background: resolvedBackground) })
      .disabled(resolvedDisabled)
      .accessibilityLabel(title)
      .buttonStyle(IconButtonPressStyle(isPressed: $isPressed, isAnimating: $isAnimating))
  }

  // MARK: Views

  private func content(foreground: Color, background: Color) -> some View {
    label(foreground: foreground)
      .padding(.horizontal, contentPadding)
      .frame(width: width, height: buttonSize.height, alignment: Alignment(horizontal: contentAlignment, vertical: .center))
      .contentShape(Rectangle())
      .background(
        RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
          .fill(background)
          .scaleEffect(
            x: isAnimating ? pressedScaleX : CustomButtonConfiguration.normalScale,
            y: isAnimating ? pressedScaleY : CustomButtonConfiguration.normalScale
          )
          .animation(.easeOut(duration: CustomButtonConfiguration.backgroundAnimationDuration), value: isAnimating)
      )
  }

  @ViewBuilder
  private func label(foreground: Color) -> some View {
    let iconView = IconView(
      Icon(symbolName: symbolName, accessibilityLabel: title, color: foreground, accentColor: nil),
      size: resolvedFontSize,
      weight: contentWeight
    )
    let textView = Text(title)
      .font(.system(size: resolvedFontSize, weight: contentWeight))
      .foregroundStyle(foreground)

    HStack(spacing: contentSpacing) {
      if iconTrailing {
        textView
        iconView
      }
      else {
        iconView
        textView
      }
    }
    .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: isPressed)
  }

  // MARK: Computed Helpers

  /// The size shared by both the icon and the text. Defaults to
  /// `CustomButtonConfiguration.iconSize(for: buttonSize.height)` — the same
  /// value `IconButton` uses for its square case — unless `.fontSize(_:)`
  /// overrides it.
  private var resolvedFontSize: CGFloat {
    fontSizeOverride ?? CustomButtonConfiguration.iconSize(for: buttonSize.height)
  }

  private var contentWeight: Font.Weight {
    isPressed ? theme.weight.bolder(by: CustomButtonConfiguration.pressedWeightSteps) : theme.weight
  }

  /// The scale ratio that grows the background's width by exactly
  /// `pressExpansion` points on each side.
  private var pressedScaleX: CGFloat {
    (width + pressExpansion * 2) / width
  }

  /// The scale ratio that grows the background's height by exactly
  /// `pressExpansion` points on each side.
  private var pressedScaleY: CGFloat {
    (buttonSize.height + pressExpansion * 2) / buttonSize.height
  }
}

// MARK: Preview

#Preview("Text Button") {
  VStack(spacing: 16) {
    // Default title, sourced from IconType.accessibilityLabel ("Undo" / "Redo").
    HStack(spacing: 8) {
      TextButton(icon: .undo, style: .circle, action: {})
      TextButton(icon: .redo, style: .circle, action: {})
    }
    HStack(spacing: 8) {
      TextButton(icon: .back, action: {})
        .buttonWidth(130)
      // Trailing Icon
      TextButton(icon: .forward, action: {})
        .iconTrailing()
        .buttonWidth(130)
    }
    // Explicit title override.
    HStack(spacing: 8) {
      TextButton("Save", icon: .done, action: {})
      TextButton("Push", icon: .left, action: {})
    }
    // contentAlignment demo on a wider button with a short label.
    VStack(spacing: 8) {
      TextButton(icon: .undo, action: {})
        .buttonWidth(180)
        .contentAlignment(.leading)
      TextButton(icon: .undo, action: {})
        .buttonWidth(180)
        .contentAlignment(.center)
      TextButton(icon: .undo, action: {})
        .buttonWidth(180)
        .contentAlignment(.trailing)
    }
  }
  .padding()
}

#Preview("Text Button Disabled") {
  VStack(spacing: 16) {
    TextButton(icon: .done, action: {})
    TextButton(icon: .done, action: {}).disabled(true)
    TextButton(icon: .done, isDisabled: true, action: {})
  }
  .padding()
}

#Preview("Text Button Font Size") {
  VStack(spacing: 16) {
    // Default: tied to buttonSize via CustomButtonConfiguration.iconSize(for:).
    TextButton(icon: .undo, action: {})

    // Larger font, same button height — icon and text both scale together.
    TextButton(icon: .undo, action: {})
      .fontSize(28)

    // Smaller font on a larger button — the two are fully independent once overridden.
    TextButton(icon: .undo, action: {})
      .buttonSize(60)
      .fontSize(15)
  }
  .padding()
}

#Preview("Text Button Font Size Across Sizes") {
  // .buttonSize(_:) alone (no .fontSize override) scales icon+text together,
  // since the default font size is derived from it.
  VStack(spacing: 16) {
    TextButton(icon: .redo, action: {}).buttonSize(36)
    TextButton(icon: .redo, action: {}).buttonSize(44)
    TextButton(icon: .redo, action: {}).buttonSize(60)
  }
  .padding()
}
