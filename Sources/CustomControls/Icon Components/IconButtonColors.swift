import SwiftUI

// MARK: Icon Button Colors

/// The color set applied to `IconButton`, `IconButtonGroup`, and `IconToggleButton`.
///
/// This is the piece meant to be overridden by consumers of DexterKit — pass a
/// single `IconButtonColors` value to restyle every icon button in an app:
///
/// ```swift
/// .iconButtonTheme(
///   IconButtonTheme(
///     colors: IconButtonColors(
///       foreground: appearance.buttonIcon,
///       background: appearance.buttonBackground,
///       backgroundDisabled: appearance.buttonBackgroundDisabled
///     )
///   )
/// )
/// ```
public struct IconButtonColors: Equatable, Sendable {

  // MARK: Properties

  /// The icon (and, where applicable, text) color in its normal, enabled state.
  public var foreground: Color

  /// The button's background in its normal, enabled state.
  public var background: Color

  /// The icon/text color while disabled. Defaults to `nil`, which dims
  /// `foreground` by the standard disabled opacity — set an explicit color to
  /// use a solid swap instead of a fade.
  public var foregroundDisabled: Color?

  /// The button's background while disabled. Defaults to `nil`, which dims
  /// `background` by the standard disabled opacity — set an explicit color
  /// (e.g. a lighter surface token) to use a solid swap instead of a fade.
  public var backgroundDisabled: Color?

  // MARK: Initialization

  public init(
    foreground: Color = .black,
    background: Color = .init(white: 0.9),
    foregroundDisabled: Color? = nil,
    backgroundDisabled: Color? = nil
  ) {
    self.foreground = foreground
    self.background = background
    self.foregroundDisabled = foregroundDisabled
    self.backgroundDisabled = backgroundDisabled
  }

  // MARK: Defaults

  /// The historical DexterKit look: `.primary` icon on an adaptive neutral
  /// background, disabled state expressed purely through opacity on both.
  public static let `default` = IconButtonColors()

  // MARK: Resolution

  /// The foreground to render for a given per-call override and enabled state.
  ///
  /// An explicit `override` always wins over the theme; while disabled it's
  /// dimmed by the standard disabled opacity, since a per-call override has no
  /// disabled variant of its own to fall back to. With no override, disabled
  /// state uses `foregroundDisabled` if set, otherwise dims `foreground`.
  func resolvedForeground(override: Color?, disabled: Bool) -> Color {
    if let override {
      return disabled ? override.opacity(CustomButtonConfiguration.disabledOpacity) : override
    }
    guard disabled else { return foreground }
    return foregroundDisabled ?? foreground.opacity(CustomButtonConfiguration.disabledOpacity)
  }

  /// The background to render for a given per-call override and enabled state.
  /// Same override/dimming rules as `resolvedForeground(override:disabled:)`.
  func resolvedBackground(override: Color?, disabled: Bool) -> Color {
    if let override {
      return disabled ? override.opacity(CustomButtonConfiguration.disabledOpacity) : override
    }
    guard disabled else { return background }
    return backgroundDisabled ?? background.opacity(CustomButtonConfiguration.disabledOpacity)
  }
}
