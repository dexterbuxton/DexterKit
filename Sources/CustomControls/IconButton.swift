import SwiftUI

/// A tappable button rendering a symbol inside a styled background frame.
///
/// Size, color overrides, and press expansion come from the environment
/// rather than init parameters, so the initializer stays small:
///
/// ```swift
/// IconButton(.undo, action: undo)                 // themed, default size
/// IconButton(.delete, action: delete)
///   .iconColor(.red)                               // per-call override
/// IconButton(AppIcon.sparkle, action: {})          // any custom symbol
/// ```
///
/// `IconType` cases keep their leading-dot spelling via a dedicated overload;
/// any other `IconRepresentable` flows through the generic initializer. Use the
/// `Icon` initializer when you already have a pre-coloured icon value — an
/// `.iconColor(_:)` override still wins over a pre-coloured `Icon` if both
/// are present, since the environment is the more specific, more local choice.
///
/// ### Environment
///
/// - `.buttonSize(_:)` — width and height. Defaults to `CustomButtonConfiguration.buttonSize`.
/// - `.buttonPressExpansion(_:)` — fixed-point background growth on press.
/// - `.iconColor(_:)` / `.iconBackground(_:)` — override `IconButtonTheme` colors.
///
/// ### Disabling
///
/// Works exactly like a native SwiftUI `Button`: pass `isDisabled:` at the
/// call site, chain `.disabled(_:)`, or both — they combine.
///
/// ```swift
/// IconButton(.undo, isDisabled: !canUndo, action: undo)  // call-site
/// IconButton(.undo, action: undo).disabled(!canUndo)     // modifier
/// ```
public struct IconButton: View {

  // MARK: Properties

  private let symbolName: String?
  private let accessibilityLabel: String
  private let accentColor: Color?
  private let colorOverride: Color?
  private let style: CustomButtonStyle
  private let isDisabled: Bool
  private let action: () -> Void

  @State private var isPressed = false
  @State private var isAnimating = false

  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.buttonSize) private var size
  @Environment(\.buttonPressExpansion) private var pressExpansion
  @Environment(\.iconColorOverride) private var iconColorOverride
  @Environment(\.iconBackgroundOverride) private var iconBackgroundOverride

  // MARK: Initialization

  /// Creates a button with a pre-coloured `Icon`. The icon's color is used
  /// unless an `.iconColor(_:)` override is present in the environment.
  public init(
    _ icon: Icon,
    style: CustomButtonStyle = .circle,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.symbolName = icon.symbolName
    self.accessibilityLabel = icon.accessibilityLabel
    self.accentColor = icon.accentColor
    self.colorOverride = icon.color
    self.style = style
    self.isDisabled = isDisabled
    self.action = action
  }

  /// Creates a button from a built-in `IconType`. Kept as a concrete overload so
  /// leading-dot cases (`.undo`, `.delete`) continue to resolve.
  public init(
    _ type: IconType,
    style: CustomButtonStyle = .circle,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.symbolName = type.symbolName
    self.accessibilityLabel = type.accessibilityLabel
    self.accentColor = nil
    self.colorOverride = nil
    self.style = style
    self.isDisabled = isDisabled
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    let resolvedDisabled = isDisabled || !isEnabled
    let resolvedForeground = theme.colors.resolvedForeground(
      override: iconColorOverride ?? colorOverride,
      disabled: resolvedDisabled
    )
    let resolvedBackground = theme.colors.resolvedBackground(override: iconBackgroundOverride, disabled: resolvedDisabled)
    let icon = Icon(
      symbolName: symbolName,
      accessibilityLabel: accessibilityLabel,
      color: resolvedForeground,
      accentColor: accentColor
    )

    Button(action: action, label: { content(icon: icon, background: resolvedBackground) })
      .disabled(resolvedDisabled)
      .accessibilityLabel(accessibilityLabel)
      .buttonStyle(IconButtonPressStyle(isPressed: $isPressed, isAnimating: $isAnimating))
  }

  // MARK: Views

  /// Icon and background as independent layers: the icon scales
  /// proportionally on press while the background grows by a fixed point
  /// value (`pressExpansion`) rather than scaling with it — so a wide button
  /// doesn't stretch its short side by the same proportion as its long side.
  private func content(icon: Icon, background: Color) -> some View {
    IconView(icon, size: CustomButtonConfiguration.iconSize(for: size), weight: iconWeight)
      .scaleEffect(isPressed ? CustomButtonConfiguration.pressedIconScale : CustomButtonConfiguration.normalIconScale)
      .opacity(isPressed ? CustomButtonConfiguration.pressedIconOpacity : CustomButtonConfiguration.enabledOpacity)
      .animation(.easeOut(duration: CustomButtonConfiguration.iconScaleAnimationDuration), value: isPressed)
      .animation(.easeOut(duration: CustomButtonConfiguration.iconAnimationDuration), value: isPressed)
      .frame(width: size, height: size)
      .contentShape(Rectangle())
      .background(
        RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
          .fill(background)
          .scaleEffect(isAnimating ? backgroundExpansionRatio : CustomButtonConfiguration.normalScale)
          .animation(.easeOut(duration: CustomButtonConfiguration.backgroundAnimationDuration), value: isAnimating)
      )
  }

  // MARK: Computed Helpers

  private var iconWeight: Font.Weight {
    isPressed ? theme.weight.bolder(by: CustomButtonConfiguration.pressedWeightSteps) : theme.weight
  }

  /// The scale ratio that produces exactly `pressExpansion` points of
  /// background growth on every side, regardless of `size`. Expressed as a
  /// ratio (rather than a literal frame resize) so it composes with
  /// `scaleEffect`'s existing animation machinery.
  private var backgroundExpansionRatio: CGFloat {
    (size + pressExpansion * 2) / size
  }
}

// MARK: Preview

#Preview("Icon Button") {
  VStack(spacing: 16) {
    HStack(spacing: 12) {
      IconButton(.undo, action: {})
      IconButton(.redo, action: {})
      IconButton(.done, action: {}).iconColor(.green)
      IconButton(.trash, action: {}).iconColor(.red)
    }
    HStack(spacing: 12) {
      IconButton(.undo, style: .square, action: {})
      IconButton(.redo, style: .square, action: {})
      IconButton(.done, style: .square, action: {}).iconColor(.green)
      IconButton(.trash, style: .square, action: {}).iconColor(.red)
    }
  }
  .padding()
}

#Preview("Icon Button Disabled") {

  // A fully custom theme - with & without disabled colors

  let defaultColors = IconButtonColors(
    foreground: Color(white: 0.2),
    background: Color(white: 0.9)
  )
  let defaultTheme = IconButtonTheme(colors: defaultColors)

  let defaultDisabledColors = IconButtonColors(
    foreground: Color(white: 0.2),
    background: Color(white: 0.9),
    foregroundDisabled: Color(white: 0.2).opacity(0.4),
    backgroundDisabled: Color(white: 0.9).opacity(0.4)
  )
  let defaultDisabledTheme = IconButtonTheme(colors: defaultDisabledColors)

  let customColors = IconButtonColors(foreground: .red, background: .black)
  let custom = IconButtonTheme(colors: customColors)

  let customDisabledColors = IconButtonColors(
    foreground: .red,
    background: .black,
    foregroundDisabled: .black,
    backgroundDisabled: .red
  )
  let customDisabled = IconButtonTheme(colors: customDisabledColors)

  return VStack(alignment: .leading, spacing: 24) {
    HStack(spacing: 12) {
      IconButton(.cancel, style: .square, action: {})
        .theme(defaultTheme)
      IconButton(.cancel, style: .square, action: {})
        .theme(defaultTheme)
        .disabled(true)
      IconButton(.cancel, style: .square, action: {})
        .theme(defaultDisabledTheme)
        .disabled(true)
    }

    HStack(spacing: 12) {
      IconButton(.cancel, style: .square, action: {})
        .theme(custom)
      IconButton(.cancel, style: .square, action: {})
        .theme(custom)
        .disabled(true)
      IconButton(.cancel, style: .square, action: {})
        .theme(customDisabled)
        .disabled(true)
    }
  }
  .padding()
}
