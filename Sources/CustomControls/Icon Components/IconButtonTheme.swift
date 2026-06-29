import SwiftUI

// MARK: Icon Button Theme

/// The look shared by `IconButton`, `IconButtonGroup`, and `IconToggleButton`.
///
/// Theming is *opt-in*: the default value reproduces the historical literals
/// (`.primary` icon on an adaptive neutral background), so buttons render
/// correctly with no setup — the slider-style "pick it up and use it" path. Set
/// a theme once near the root to restyle every button beneath it:
///
/// ```swift
/// ContentView()
///   .iconButtonTheme(
///     IconButtonTheme(iconColor: appearance.buttonIcon, backgroundColor: appearance.buttonBackground)
///   )
/// ```
///
/// Per-call `color` / `backgroundColor` / `iconWeight` arguments always win over
/// the theme, so a single destructive symbol can still be tinted in place.
public struct IconButtonTheme: Equatable, Sendable {

  // MARK: Properties

  public var iconColor: Color
  public var backgroundColor: Color
  public var iconWeight: Font.Weight

  // MARK: Initialization

  public init(
    iconColor: Color = .primary,
    backgroundColor: Color = Color.primary.opacity(0.08),
    iconWeight: Font.Weight = CustomButtonConfiguration.iconWeight
  ) {
    self.iconColor = iconColor
    self.backgroundColor = backgroundColor
    self.iconWeight = iconWeight
  }
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
  func iconButtonTheme(_ theme: IconButtonTheme) -> some View {
    environment(\.iconButtonTheme, theme)
  }
}
