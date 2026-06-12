import SwiftUI

/// A tappable button rendering an icon inside a styled background frame.
///
/// The background and icon colors are passed in (no theming environment), matching
/// `CustomIndicatorButton`. Use the full initializer with an explicit `Icon`, or
/// the convenience initializer to build one from an `IconType`.
///
/// ```swift
/// // Convenience — icon color and background as arguments
/// IconButton(.undo, action: undo)
///
/// // Full — custom Icon (e.g. a two-tone color)
/// IconButton(Icon(.delete, color: .red), action: delete)
/// ```
public struct IconButton: View {

  // MARK: Properties

  private let icon: Icon
  private let style: CustomButtonStyle
  private let size: CGFloat
  private let backgroundColor: Color
  private let iconWeight: Font.Weight
  private let isDisabled: Bool
  private let action: () -> Void

  // MARK: Initialization

  /// Creates a button with an explicit `Icon`.
  ///
  /// - Parameters:
  ///   - icon: The icon to display, carrying type and color.
  ///   - style: The background shape. Defaults to circle.
  ///   - size: The square frame size. Defaults to `CustomButtonConfiguration.buttonSize`.
  ///   - backgroundColor: The background fill. Defaults to an adaptive neutral.
  ///   - iconWeight: Font weight for the icon. Defaults to `CustomButtonConfiguration.iconWeight`.
  ///   - isDisabled: Whether the button is non-interactive. Defaults to false.
  ///   - action: The closure to invoke on tap.
  public init(
    _ icon: Icon,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    backgroundColor: Color = Color.primary.opacity(0.08),
    iconWeight: Font.Weight = CustomButtonConfiguration.iconWeight,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.style = style
    self.size = size
    self.backgroundColor = backgroundColor
    self.iconWeight = iconWeight
    self.isDisabled = isDisabled
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    Button(action: action) {
      IconView(icon, size: size * CustomButtonConfiguration.iconSizeRatio, weight: iconWeight)
        .opacity(isDisabled ? CustomButtonConfiguration.disabledOpacity : CustomButtonConfiguration.enabledOpacity)
        .frame(width: size, height: size)
        .contentShape(Rectangle())
        .background(
          RoundedRectangle(cornerRadius: CustomButtonConfiguration.cornerRadius(for: style))
            .fill(backgroundColor)
        )
    }
    .disabled(isDisabled)
    .accessibilityLabel(icon.type.accessibilityLabel)
    .buttonStyle(CustomButtonPressStyle())
  }
}

// MARK: Convenience Init

extension IconButton {

  /// Creates a button from an `IconType`, building the `Icon` from the given colors.
  ///
  /// - Parameters:
  ///   - type: The icon type to display.
  ///   - style: The background shape. Defaults to circle.
  ///   - size: The square frame size. Defaults to `CustomButtonConfiguration.buttonSize`.
  ///   - color: The icon color. Defaults to `.primary`.
  ///   - backgroundColor: The background fill. Defaults to an adaptive neutral.
  ///   - accentColor: Optional secondary color for two-tone SF Symbols.
  ///   - iconWeight: Font weight for the icon. Defaults to `CustomButtonConfiguration.iconWeight`.
  ///   - isDisabled: Whether the button is non-interactive. Defaults to false.
  ///   - action: The closure to invoke on tap.
  public init(
    _ type: IconType,
    style: CustomButtonStyle = .circle,
    size: CGFloat = CustomButtonConfiguration.buttonSize,
    color: Color = .primary,
    backgroundColor: Color = Color.primary.opacity(0.08),
    accentColor: Color? = nil,
    iconWeight: Font.Weight = CustomButtonConfiguration.iconWeight,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.init(
      Icon(type, color: color, accentColor: accentColor),
      style: style,
      size: size,
      backgroundColor: backgroundColor,
      iconWeight: iconWeight,
      isDisabled: isDisabled,
      action: action
    )
  }
}

// MARK: Preview

#Preview("Icon Button") {
  VStack(spacing: 16) {
    HStack(spacing: 12) {
      IconButton(.undo, action: {})
      IconButton(.redo, action: {})
      IconButton(.done, color: .green, action: {})
      IconButton(.delete, color: .red, action: {})
    }
    HStack(spacing: 12) {
      IconButton(.undo, style: .rectangle, action: {})
      IconButton(.gridOn, style: .rectangle, action: {})
      IconButton(.clear, style: .rectangle, isDisabled: true, action: {})
    }
  }
  .padding()
}
