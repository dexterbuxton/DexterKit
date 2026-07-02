import SwiftUI

// MARK: Icon Button Theme

/// The look shared by `IconButton`, `IconButtonGroup`, and `IconToggleButton`.
///
/// Theming is *opt-in*: the default value reproduces the historical literals
/// (`.primary` icon on an adaptive neutral background), so buttons render
/// correctly with no setup. Set a theme once near the root to restyle every
/// button beneath it:
///
/// ```swift
/// ContentView()
///   .iconButtonTheme(
///     IconButtonTheme(
///       colors: IconButtonColors(
///         foreground: appearance.buttonIcon,
///         background: .appSurfaceMedium,
///         backgroundDisabled: .appSurfaceLight
///       )
///     )
///   )
/// ```
///
/// Per-call `color` / `backgroundColor` / `iconWeight` arguments on individual
/// buttons still win over the theme, so a single destructive symbol can still
/// be tinted in place.
public struct IconButtonTheme: Equatable, Sendable {

  // MARK: Properties

  /// The color set. Override this one value to restyle every icon button at once.
  public var colors: IconButtonColors

  /// The icon weight in its resting (unpressed) state.
  public var weight: Font.Weight

  // MARK: Initialization

  public init(
    colors: IconButtonColors = .default,
    weight: Font.Weight = CustomButtonConfiguration.iconWeight
  ) {
    self.colors = colors
    self.weight = weight
  }

  // MARK: Defaults

  /// The historical `.primary`-on-neutral look.
  public static let `default` = IconButtonTheme()
}

// MARK: Environment

private struct IconButtonThemeKey: EnvironmentKey {
  static let defaultValue = IconButtonTheme()
}

public extension EnvironmentValues {

  /// The theme applied to icon buttons in this view hierarchy.
  var iconButtonTheme: IconButtonTheme {
    get { self[IconButtonThemeKey.self] }
    set { self[IconButtonThemeKey.self] = newValue }
  }
}

public extension View {

  /// Sets the `IconButtonTheme` for icon buttons in this view hierarchy.
  ///
  /// Per-call color and weight arguments still override the theme.
  func theme(_ theme: IconButtonTheme) -> some View {
    environment(\.iconButtonTheme, theme)
  }
}
