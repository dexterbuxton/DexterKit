import SwiftUI

/// Single source of truth for button-specific configuration values.
/// This includes: ratios, animation constants, corner radii, and spacing.
public enum CustomButtonConfiguration {

  // MARK: Size

  /// The default width and height of each button.
  public static let buttonSize: CGFloat = 44

  // MARK: Corner Radius

  /// Corner radius for circle style buttons.
  public static let circleCornerRadius: CGFloat = .infinity

  /// Corner radius for rectangle style buttons.
  public static let roundedRectangleCornerRadius: CGFloat = 8

  // MARK: Typography

  /// Default font weight for icons and number text.
  public static let iconWeight: Font.Weight = .medium

  /// Font design for number text.
  public static let numberFontDesign: Font.Design = .rounded

  /// Symbol rendering mode for SF Symbols.
  public static let symbolRenderingMode: SymbolRenderingMode = .palette

  // MARK: Ratios

  /// Ratio of icon font size to button size (~24pt at the default 44pt button).
  public static let iconSizeRatio: CGFloat = 0.545

  /// Ratio of indicator dot diameter to button size (~13pt at the default 44pt button).
  public static let indicatorDotRatio: CGFloat = 0.3

  // MARK: Opacity

  /// Opacity for disabled buttons.
  public static let disabledOpacity: Double = 0.4

  /// Opacity for enabled buttons.
  public static let enabledOpacity: Double = 1.0

  /// Opacity for the icon when a button is actively pressed.
  public static let pressedIconOpacity: Double = 0.7

  // MARK: Animation

  /// Scale applied to a standalone button's background when pressed.
  public static let pressedBackgroundScale: CGFloat = 1.15

  /// Identity scale (no scaling).
  public static let normalScale: CGFloat = 1.0

  /// Duration of background scale animations.
  public static let backgroundAnimationDuration: Double = 0.2

  /// Duration of icon opacity animations.
  public static let iconAnimationDuration: Double = 0.1

  /// Scale applied to an icon when its button is pressed.
  public static let pressedIconScale: CGFloat = 1.05

  /// Identity scale for icons.
  public static let normalIconScale: CGFloat = 1.0

  /// Duration of icon scale animations.
  public static let iconScaleAnimationDuration: Double = 0.05

  /// Minimum animation cycle in nanoseconds.
  ///
  /// Ensures the background completes a full scale-up and scale-down animation
  /// even for quick taps shorter than this duration.
  public static let minimumAnimationCycle: UInt64 = 250_000_000

  // MARK: Spacing

  /// Default spacing between buttons in a group.
  public static let groupSpacing: CGFloat = 8

  /// Inner horizontal padding added to capsule-style groups.
  public static let groupInnerPadding: CGFloat = 6

  // MARK: Computed Helpers

  /// Returns the corner radius for a given button style.
  public static func cornerRadius(for style: CustomButtonStyle) -> CGFloat {
    switch style {
    case .circle: circleCornerRadius
    case .rectangle: roundedRectangleCornerRadius
    }
  }

  /// Returns the icon font size for a given button size.
  public static func iconSize(for buttonSize: CGFloat) -> CGFloat {
    buttonSize * iconSizeRatio
  }
}
