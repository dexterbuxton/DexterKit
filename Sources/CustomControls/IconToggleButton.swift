import SwiftUI

/// A standalone toggle button that cross-fades between two symbols.
///
/// Driven by a `Bool` binding: tapping flips the binding, and because the visual
/// is keyed on the value rather than the gesture, an *external* change to the
/// binding cross-fades exactly the same way. The press scale/opacity/background
/// feel is identical to `IconButton` — both ride `CustomButtonPressStyle`.
///
/// ```swift
/// IconToggleButton(isOn: $isPlaying, on: IconType.toggleOn, off: IconType.toggleOff)
/// IconToggleButton(isOn: $isOn, on: .toggleOn, off: .toggleOff)   // IconType pair
/// IconToggleButton(isOn: $isOn, on: AppIcon.play, off: AppIcon.pause)
/// ```
///
/// Colors and weight come from the `IconButtonTheme` unless overridden per call.
///
/// ### Disabling
///
/// Same model as `IconButton`: pass `isDisabled:` at the call site, chain
/// `.disabled(_:)`, or both — they compose. Both colors dim via opacity by
/// default, or solid-swap if `IconButtonColors.foregroundDisabled` /
/// `backgroundDisabled` are set.
public struct IconToggleButton: View {

  // MARK: Properties

  private let onSymbol: String?
  private let onLabel: String
  private let offSymbol: String?
  private let offLabel: String
  private let accentColor: Color?
  private let colorOverride: Color?
  private let backgroundOverride: Color?
  private let weightOverride: Font.Weight?
  private let style: CustomButtonStyle
  private let width: CGFloat
  private let height: CGFloat
  private let isDisabled: Bool
  private let onToggle: ((Bool) -> Void)?

  @Binding private var isOn: Bool
  @Environment(\.iconButtonTheme) private var theme
  @Environment(\.isEnabled) private var isEnabled

  // MARK: Initialization

  /// Creates a square toggle from two built-in `IconType` symbol. Concrete
  /// overload so leading-dot cases (`.toggleOn`, `.toggleOff`) keep resolving.
  public init(
    isOn: Binding<Bool>,
    on onType: IconType,
    off offType: IconType,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color? = nil,
    backgroundColor: Color? = nil,
    accentColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    onToggle: ((Bool) -> Void)? = nil
  ) {
    self.init(
      isOn: isOn,
      on: onType,
      off: offType,
      style: style,
      width: size,
      height: size,
      color: color,
      backgroundColor: backgroundColor,
      accentColor: accentColor,
      iconWeight: iconWeight,
      isDisabled: isDisabled,
      onToggle: onToggle
    )
  }

  /// Creates a square toggle from any two symbol identities.
  public init(
    isOn: Binding<Bool>,
    on onSymbol: some IconRepresentable,
    off offSymbol: some IconRepresentable,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color? = nil,
    backgroundColor: Color? = nil,
    accentColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    onToggle: ((Bool) -> Void)? = nil
  ) {
    self.init(
      isOn: isOn,
      on: onSymbol,
      off: offSymbol,
      style: style,
      width: size,
      height: size,
      color: color,
      backgroundColor: backgroundColor,
      accentColor: accentColor,
      iconWeight: iconWeight,
      isDisabled: isDisabled,
      onToggle: onToggle
    )
  }

  /// Creates a toggle with independent width and height from any two symbols.
  public init(
    isOn: Binding<Bool>,
    on onSymbol: some IconRepresentable,
    off offSymbol: some IconRepresentable,
    style: CustomButtonStyle = .circle,
    width: CGFloat,
    height: CGFloat,
    color: Color? = nil,
    backgroundColor: Color? = nil,
    accentColor: Color? = nil,
    iconWeight: Font.Weight? = nil,
    isDisabled: Bool = false,
    onToggle: ((Bool) -> Void)? = nil
  ) {
    self._isOn = isOn
    self.onSymbol = onSymbol.symbolName
    self.onLabel = onSymbol.accessibilityLabel
    self.offSymbol = offSymbol.symbolName
    self.offLabel = offSymbol.accessibilityLabel
    self.accentColor = accentColor
    self.colorOverride = color
    self.backgroundOverride = backgroundColor
    self.weightOverride = iconWeight
    self.style = style
    self.width = width
    self.height = height
    self.isDisabled = isDisabled
    self.onToggle = onToggle
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
    let iconSize = min(width, height) * CustomButtonConfiguration.iconSizeRatio
    let onIcon = Icon(symbolName: onSymbol, accessibilityLabel: onLabel, color: resolvedColor, accentColor: accentColor)
    let offIcon = Icon(symbolName: offSymbol, accessibilityLabel: offLabel, color: resolvedColor, accentColor: accentColor)

    Button {
      isOn.toggle()
      onToggle?(isOn)
    } label: {
      ZStack {
        IconView(onIcon, size: iconSize, weight: resolvedWeight)
          .opacity(isOn ? CustomButtonConfiguration.enabledOpacity : 0)
        IconView(offIcon, size: iconSize, weight: resolvedWeight)
          .opacity(isOn ? 0 : CustomButtonConfiguration.enabledOpacity)
      }
      .animation(.easeInOut(duration: CustomButtonConfiguration.iconCrossfadeDuration), value: isOn)
      .frame(width: width, height: height)
      .contentShape(Rectangle())
      .background(
        RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
          .fill(resolvedBackground)
      )
    }
    .disabled(resolvedDisabled)
    .accessibilityLabel(accessibilityText)
    .accessibilityAddTraits(isOn ? .isSelected : [])
    .buttonStyle(CustomButtonPressStyle())
  }

  // MARK: Computed Helpers

  /// The label for the active symbol, falling back to the other symbol's label
  /// when the active one is empty (e.g. an `EmptyIcon` off-state).
  private var accessibilityText: String {
    let active = isOn ? onLabel : offLabel
    if !active.isEmpty {
      return active
    }
    return onLabel.isEmpty ? offLabel : onLabel
  }
}

// MARK: Indicator Convenience

public extension IconToggleButton {

  /// A swatch-style toggle: a filled dot fades in over a colored background when
  /// `isOn`, and out when off.
  ///
  /// - Parameters:
  ///   - isOn: Binding to the on/off state.
  ///   - style: The background shape. Defaults to circle.
  ///   - size: The square frame size.
  ///   - color: The swatch (background) color.
  ///   - dotColor: The fill color of the dot.
  static func indicator(
    isOn: Binding<Bool>,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color,
    dotColor: Color
  ) -> IconToggleButton {
    IconToggleButton(
      isOn: isOn,
      on: FilledDotIcon(),
      off: EmptyIcon(),
      style: style,
      size: size,
      color: dotColor,
      backgroundColor: color
    )
  }
}

// MARK: Preview

#Preview("Icon Toggle Button") {
  struct TogglePreview: View {
    @State private var toggle1 = false
    @State private var toggle2 = false

    var body: some View {
      HStack(spacing: 16) {
        IconToggleButton(
          isOn: $toggle1,
          on: .toggleOn,
          off: .toggleOff,
          style: .circle
        )
        IconToggleButton(
          isOn: $toggle2,
          on: .copyReady,
          off: .copy,
          style: .square
        )
      }
      .padding()
    }
  }

  return TogglePreview()
}

#Preview("Icon Toggle Button Disabled") {
  struct TogglePreview: View {
    @State private var toggle1 = false
    @State private var toggle2 = false
    @State private var toggle3 = false
    @State private var toggle4 = false
    @State private var toggle5 = false
    @State private var toggle6 = false

    var body: some View {
      // Same color definitions as the "Icon Button Disabled" preview.
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
          IconToggleButton(isOn: $toggle1, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(defaultTheme)
          // 2: Default - disabled via opacity.
          IconToggleButton(isOn: $toggle2, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(defaultTheme)
            .disabled(true)
          // 3: Default + Disabled Colors (Looks the same as #2)
          IconToggleButton(isOn: $toggle3, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(defaultDisabledTheme)
            .disabled(true)
        }

        HStack(spacing: 12) {
          // 1: Custom colors, not disabled.
          IconToggleButton(isOn: $toggle4, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(custom)
          // 2: Custom Colors - Disabled using dimming.
          IconToggleButton(isOn: $toggle5, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(custom)
            .disabled(true)
          // 3: Custom Colors and Custom Disable Colors.
          IconToggleButton(isOn: $toggle6, on: .toggleOn, off: .toggleOff, style: .square)
            .theme(customDisabled)
            .disabled(true)
        }
      }
      .padding()
    }
  }

  return TogglePreview()
}
