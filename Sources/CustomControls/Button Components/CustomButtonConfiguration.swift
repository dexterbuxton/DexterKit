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

  /// Corner radius for square style buttons.
  public static let squareCornerRadius: CGFloat = 8

  // MARK: Typography

  /// Default font weight for icons and number text.
  public static let iconWeight: Font.Weight = .medium

  /// Font design for number text.
  public static let numberFontDesign: Font.Design = .rounded

  /// Symbol rendering mode for SF Symbols.
  public static let symbolRenderingMode: SymbolRenderingMode = .palette

  /// How many weight steps a group icon thickens while its button is pressed.
  public static let pressedWeightSteps: Int = 2

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

  /// Proportional scale applied to a generic (unsized) content button's
  /// background when pressed — used only by `CustomButtonPressStyle`, for
  /// content whose intrinsic size DexterKit doesn't know (e.g. `PalettePicker`
  /// swatches, `CustomContentButton`). Sized icon buttons use
  /// `defaultPressExpansion` instead; see that constant's documentation.
  public static let pressedBackgroundScale: CGFloat = 1.15

  /// Fixed-point background growth applied on press to `IconButton` and
  /// `IconButtonGroup`, in each direction (so a button grows by twice this
  /// value in both width and height). Used instead of a proportional scale
  /// because a wide button in a group would otherwise stretch its short
  /// side by the same proportion as its long side. Defaults to half of
  /// `groupSpacing` (8), which keeps a pressed group button visually inside
  /// its neighbor's spacing rather than overlapping it.
  public static let defaultPressExpansion: CGFloat = 4

  /// Identity scale (no scaling).
  public static let normalScale: CGFloat = 1.0

  /// Duration of background scale/expansion animations.
  public static let backgroundAnimationDuration: Double = 0.1

  /// Duration of icon opacity animations.
  public static let iconAnimationDuration: Double = 0.1

  /// Duration of the icon cross-fade in `IconToggleButton`.
  public static let iconCrossfadeDuration: Double = 0.2

  /// Scale applied to an icon when its button is pressed.
  public static let pressedIconScale: CGFloat = 1.05

  /// Identity scale for icons.
  public static let normalIconScale: CGFloat = 1.0

  /// Duration of icon scale animations.
  public static let iconScaleAnimationDuration: Double = 0.1

  /// Minimum animation cycle in nanoseconds.
  ///
  /// Ensures the background completes a full scale-up and scale-down animation
  /// even for quick taps shorter than this duration.
  public static let minimumAnimationCycle: UInt64 = 250_000_000

  // MARK: Spacing

  /// Default spacing between buttons in a group.
  public static let groupSpacing: CGFloat = 8

  /// Maximum padding reallocated to each outer edge of an `IconButtonGroup`,
  /// taken out of its own inter-button spacing rather than added on top of
  /// it — a group's total width never changes because of this, only where
  /// the space sits.
  ///
  /// Only applies once a group's configured spacing exceeds `2`; at `2` or
  /// below, spacing is left exactly as configured, with `0` padding on
  /// either edge, regardless of how many buttons are in the group. Above
  /// that threshold, one point moves from each internal gap to the leading
  /// and trailing edges (so with `N` gaps, up to this many points end up on
  /// each side) — giving the shared background breathing room around its
  /// outermost buttons. Once a group has more gaps than this cap allows,
  /// the edges hold fixed at the cap and the remaining space distributes
  /// evenly across the gaps via flexible spacers instead of a single fixed
  /// per-gap value.
  public static let maxGroupInnerPadding: CGFloat = 6

  // MARK: Typography (Text Button)

  /// The default width of a Text Button (icon + label), used when no
  /// `.buttonWidth(_:)` override is set in the environment. Sized to fit
  /// content like "Uniform" / "Random" without truncating — adjust once
  /// rendered against real labels.
  public static let textButtonWidth: CGFloat = 120

  /// Spacing between the icon and text inside a Text Button.
  public static let textButtonContentSpacing: CGFloat = 6

  /// Horizontal inset between a Text Button's edge and its icon+text content —
  /// what shows as margin when the icon sits at the leading or trailing edge.
  public static let textButtonContentPadding: CGFloat = 12

  // MARK: Computed Helpers

  /// Returns the corner radius for a given button style.
  public static func cornerRadius(for style: CustomButtonStyle) -> CGFloat {
    switch style {
    case .circle: circleCornerRadius
    case .square: squareCornerRadius
    }
  }

  /// Returns the icon font size for a given button size.
  public static func iconSize(for buttonSize: CGFloat) -> CGFloat {
    buttonSize * iconSizeRatio
  }
}
