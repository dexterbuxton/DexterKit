import SwiftUI

/// A tappable button rendering a symbol inside a styled background frame.
///
/// Colors come from the `IconButtonTheme` in the environment unless overridden
/// per call, so a themed button is one line:
///
/// ```swift
/// IconButton(.undo, action: undo)                 // themed, built-in catalog
/// IconButton(.delete, color: .red, action: delete) // per-call override
/// IconButton(AppIcon.sparkle, action: {})          // any custom symbol
/// ```
///
/// `IconType` cases keep their leading-dot spelling via a dedicated overload;
/// any other `IconRepresentable` flows through the generic initializer. Use the
/// `Icon` initializer when you already have a pre-coloured icon value.
///
/// ### Disabling
///
/// Disabling works exactly like a native SwiftUI `Button`: pass `isDisabled:`
/// at the call site, chain `.disabled(_:)` on the view, or both — they combine
/// (SwiftUI ANDs nested `isEnabled` environment writes), so an external
/// `.disabled()` always wins even if the call site didn't set `isDisabled:`.
///
/// Either path dims (or, with `IconButtonColors.foregroundDisabled` /
/// `backgroundDisabled` set, solid-swaps) both colors, blocks taps, and gets
/// the standard disabled accessibility treatment for free.
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
  private let backgroundOverride: Color?
  private let weightOverride: Font.Weight?
  private let style: CustomButtonStyle
  private let size: CGFloat
  private let isDisabled: Bool
  private let action: () -> Void
  @State private var isPressed = false

  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled

  // MARK: Initialization

  /// Creates a button with a pre-coloured `Icon`. The icon's color is treated as
  /// an explicit override of the theme.
  public init(
    _ icon: Icon,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.symbolName = icon.symbolName
    self.accessibilityLabel = icon.accessibilityLabel
    self.accentColor = icon.accentColor
    self.colorOverride = icon.color
    self.backgroundOverride = backgroundColor
    self.weightOverride = iconWeight
    self.style = style
    self.size = size
    self.isDisabled = isDisabled
    self.action = action
  }

  /// Creates a button from a built-in `IconType`. Kept as a concrete overload so
  /// leading-dot cases (`.undo`, `.delete`) continue to resolve.
  public init(
    _ type: IconType,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color? = nil,
    backgroundColor: Color? = nil,
    accentColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(
      symbol: type,
      style: style,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      accentColor: accentColor,
      iconWeight: iconWeight,
      isDisabled: isDisabled,
      action: action
    )
  }

  /// Creates a button from any symbol identity.
  ///
  /// Leave `color` / `backgroundColor` / `iconWeight` `nil` to inherit the
  /// `IconButtonTheme`; pass a value to override it for this button only.
  public init(
    _ symbol: some IconRepresentable,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color? = nil,
    backgroundColor: Color? = nil,
    accentColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(
      symbol: symbol,
      style: style,
      size: size,
      color: color,
      backgroundColor: backgroundColor,
      accentColor: accentColor,
      iconWeight: iconWeight,
      isDisabled: isDisabled,
      action: action
    )
  }

  /// Shared designated initializer.
  private init(
    symbol: some IconRepresentable,
    style: CustomButtonStyle,
    size: CGFloat,
    color: Color?,
    backgroundColor: Color?,
    accentColor: Color?,
    iconWeight: Font.Weight?,
    isDisabled: Bool,
    action: @escaping () -> Void
  ) {
    self.symbolName = symbol.symbolName
    self.accessibilityLabel = symbol.accessibilityLabel
    self.accentColor = accentColor
    self.colorOverride = color
    self.backgroundOverride = backgroundColor
    self.weightOverride = iconWeight
    self.style = style
    self.size = size
    self.isDisabled = isDisabled
    self.action = action
  }

  // MARK: Computed Helpers

  /// Combines the call-site `isDisabled:` with any ambient `.disabled()`
  /// applied by the caller, so either path (or both) disables the button.
  private var resolvedDisabled: Bool {
    isDisabled || !isEnabled
  }

  // MARK: Body

  public var body: some View {
    let resolvedColor = theme.colors.resolvedForeground(override: colorOverride, disabled: resolvedDisabled)
    let resolvedBackground = theme.colors.resolvedBackground(override: backgroundOverride, disabled: resolvedDisabled)
    let resolvedWeight = weightOverride ?? theme.weight
    let icon = Icon(
      symbolName: symbolName,
      accessibilityLabel: accessibilityLabel,
      color: resolvedColor,
      accentColor: accentColor
    )

    Button(action: action) {
      IconView(
        icon,
        size: size * CustomButtonConfiguration.iconSizeRatio,
        weight: isPressed
          ? resolvedWeight.bolder(by: CustomButtonConfiguration.pressedWeightSteps)
          : resolvedWeight
      )
        .frame(width: size, height: size)
        .contentShape(Rectangle())
        .background(
          RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
            .fill(resolvedBackground)
        )
    }
    .disabled(resolvedDisabled)
    .accessibilityLabel(accessibilityLabel)
    .buttonStyle(CustomButtonPressStyle(isPressed: $isPressed))
  }
}

// MARK: Preview

#Preview("Icon Button") {
  VStack(spacing: 16) {
    HStack(spacing: 12) {
      IconButton(.undo, action: {})
      IconButton(.redo, action: {})
      IconButton(.done, color: .green, action: {})
      IconButton(.trash, color: .red, action: {})
    }
    HStack(spacing: 12) {
      IconButton(.undo, style: .rectangle, action: {})
      IconButton(.redo, style: .rectangle, action: {})
      IconButton(.done, style: .rectangle, color: .green, action: {})
      IconButton(.trash, style: .rectangle, color: .red, action: {})
    }
  }
  .padding()
}

#Preview("Icon Button Disabled") {

  // A fully custom theme - with & without disabled colors

  // Gray Colors - similar to default.
  let defaultColors = IconButtonColors(
    foreground: Color.init(white: 0.2),
    background: Color.init(white: 0.9)
  )
  let defaultTheme = IconButtonTheme(colors: defaultColors)

  // Gray Colors with disabled colors added at exact opacity as default
  let defaultDisabledColors = IconButtonColors(
    foreground: Color.init(white: 0.2),
    background: Color.init(white: 0.9),
    foregroundDisabled: Color.init(white: 0.2).opacity(0.4),
    backgroundDisabled: Color.init(white: 0.9).opacity(0.4)
  )
  let defaultDisabledTheme = IconButtonTheme(colors: defaultDisabledColors)

  // Red & Black - demonstrating custom colors.
  let customColors = IconButtonColors(
    foreground: .red,
    background: .black
  )
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
      // 1: Default Theme - not disabled.
      IconButton(
        .cancel,
        style: .rectangle,
        action: {
        })
      .theme(defaultTheme)
      // 2: Default - disabled via opacity.
      IconButton(
        .cancel,
        style: .rectangle,
        action: {
        })
      .theme(defaultTheme)
      .disabled(true)
      // 3: Default + Disabled Colors (Looks the same as #2)
      IconButton(
        .cancel,
        style: .rectangle,
        action: {}
      )
      .theme(defaultDisabledTheme)
      .disabled(true)
    }

    HStack(spacing: 12) {
      // 1: Custom colors, not disabled.
      IconButton(
        .cancel,
        style: .rectangle,
        action: {
        })
        .theme(custom)
      // 2: Custom Colors - Disabled using dimming.
      IconButton(
        .cancel,
        style: .rectangle,
        action: {
        })
        .theme(custom)
        .disabled(true)
      // 3: Custom Colors and Custom Disable Colors.
      IconButton(
        .cancel,
        style: .rectangle,
        action: {
        })
        .theme(customDisabled)
        .disabled(true)
    }
  }
  .padding()
}
