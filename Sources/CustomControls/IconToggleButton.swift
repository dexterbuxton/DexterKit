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

  // MARK: Body

  public var body: some View {
    let resolvedColor = colorOverride ?? theme.iconColor
    let resolvedBackground = backgroundOverride ?? theme.backgroundColor
    let resolvedWeight = weightOverride ?? theme.iconWeight
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
    .disabled(isDisabled)
    .opacity(isDisabled ? CustomButtonConfiguration.disabledOpacity : CustomButtonConfiguration.enabledOpacity)
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
          style: .rectangle
        )
      }
      .padding()
    }
  }

  return TogglePreview()
}
