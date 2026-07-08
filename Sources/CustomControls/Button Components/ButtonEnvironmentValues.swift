import SwiftUI

// MARK: Environment Keys

private struct ButtonSizeKey: EnvironmentKey {
  static let defaultValue: CGFloat = CustomButtonConfiguration.buttonSize
}

private struct ButtonPressExpansionKey: EnvironmentKey {
  static let defaultValue: CGFloat = CustomButtonConfiguration.defaultPressExpansion
}

private struct ButtonWidthKey: EnvironmentKey {
  static let defaultValue: CGFloat = CustomButtonConfiguration.textButtonWidth
}

private struct IconColorKey: EnvironmentKey {
  static let defaultValue: Color? = nil
}

private struct IconBackgroundKey: EnvironmentKey {
  static let defaultValue: Color? = nil
}

private struct TextButtonIconTrailingKey: EnvironmentKey {
  static let defaultValue = false
}

private struct TextButtonContentAlignmentKey: EnvironmentKey {
  static let defaultValue: HorizontalAlignment = .center
}

private struct TextButtonContentSpacingKey: EnvironmentKey {
  static let defaultValue: CGFloat = CustomButtonConfiguration.textButtonContentSpacing
}

private struct TextButtonContentPaddingKey: EnvironmentKey {
  static let defaultValue: CGFloat = CustomButtonConfiguration.textButtonContentPadding
}

private struct TextButtonFontSizeKey: EnvironmentKey {
  /// `nil` means "match `IconButton`'s tied-to-size default" —
  /// `CustomButtonConfiguration.iconSize(for:)` — rather than a fixed literal,
  /// since the default legitimately depends on `buttonSize`.
  static let defaultValue: CGFloat? = nil
}

extension EnvironmentValues {

  /// The width and height applied to `IconButton` / `IconButtonGroup` items
  /// beneath this view. Defaults to `CustomButtonConfiguration.buttonSize`.
  public var buttonSize: CGFloat {
    get { self[ButtonSizeKey.self] }
    set { self[ButtonSizeKey.self] = newValue }
  }

  /// The fixed-point background growth applied on press to icon buttons and
  /// Text Buttons beneath this view. Defaults to
  /// `CustomButtonConfiguration.defaultPressExpansion`.
  public var buttonPressExpansion: CGFloat {
    get { self[ButtonPressExpansionKey.self] }
    set { self[ButtonPressExpansionKey.self] = newValue }
  }

  /// The fixed width applied to Text Buttons beneath this view. Defaults to
  /// `CustomButtonConfiguration.textButtonWidth`.
  public var buttonWidth: CGFloat {
    get { self[ButtonWidthKey.self] }
    set { self[ButtonWidthKey.self] = newValue }
  }

  /// An explicit icon foreground override, taking precedence over
  /// `IconButtonTheme`. `nil` (the default) defers to the theme.
  public var iconColorOverride: Color? {
    get { self[IconColorKey.self] }
    set { self[IconColorKey.self] = newValue }
  }

  /// An explicit icon background override, taking precedence over
  /// `IconButtonTheme`. `nil` (the default) defers to the theme.
  public var iconBackgroundOverride: Color? {
    get { self[IconBackgroundKey.self] }
    set { self[IconBackgroundKey.self] = newValue }
  }

  /// Whether a Text Button's icon renders after its text instead of before.
  /// `false` (leading) by default.
  public var textButtonIconTrailing: Bool {
    get { self[TextButtonIconTrailingKey.self] }
    set { self[TextButtonIconTrailingKey.self] = newValue }
  }

  /// Where a Text Button's icon+text group sits inside its fixed width when
  /// the content doesn't fill it. `.center` by default.
  public var textButtonContentAlignment: HorizontalAlignment {
    get { self[TextButtonContentAlignmentKey.self] }
    set { self[TextButtonContentAlignmentKey.self] = newValue }
  }

  /// The gap between a Text Button's icon and text. Defaults to
  /// `CustomButtonConfiguration.textButtonContentSpacing`.
  public var textButtonContentSpacing: CGFloat {
    get { self[TextButtonContentSpacingKey.self] }
    set { self[TextButtonContentSpacingKey.self] = newValue }
  }

  /// The horizontal inset between a Text Button's edge and its icon+text
  /// content. Defaults to `CustomButtonConfiguration.textButtonContentPadding`.
  public var textButtonContentPadding: CGFloat {
    get { self[TextButtonContentPaddingKey.self] }
    set { self[TextButtonContentPaddingKey.self] = newValue }
  }

  /// An explicit icon+text size for Text Buttons, overriding the default of
  /// `CustomButtonConfiguration.iconSize(for: buttonSize)`. `nil` (the
  /// default) keeps icon and text tied to `.buttonSize(_:)`.
  public var textButtonFontSizeOverride: CGFloat? {
    get { self[TextButtonFontSizeKey.self] }
    set { self[TextButtonFontSizeKey.self] = newValue }
  }
}

// MARK: View Modifiers

extension View {

  /// Sets the fixed-point background growth applied on press to icon buttons
  /// and Text Buttons beneath this view.
  public func buttonPressExpansion(_ value: CGFloat) -> some View {
    environment(\.buttonPressExpansion, value)
  }

  /// Sets the fixed width for Text Buttons beneath this view.
  public func buttonWidth(_ width: CGFloat) -> some View {
    environment(\.buttonWidth, width)
  }

  /// Sets the height for `IconButton` / `IconButtonGroup` items beneath this view.
  public func buttonHeight(_ size: CGFloat) -> some View {
    environment(\.buttonSize, size)
  }

  /// Overrides the icon foreground color, taking precedence over `IconButtonTheme`.
  public func iconColor(_ color: Color?) -> some View {
    environment(\.iconColorOverride, color)
  }

  /// Overrides the icon background color, taking precedence over `IconButtonTheme`.
  public func iconBackground(_ color: Color?) -> some View {
    environment(\.iconBackgroundOverride, color)
  }

  /// Moves a Text Button's icon after its text instead of before. Pass `false`
  /// to explicitly reset back to leading.
  public func iconTrailing(_ trailing: Bool = true) -> some View {
    environment(\.textButtonIconTrailing, trailing)
  }

  /// Positions a Text Button's icon+text group within its fixed width.
  /// `.center` by default; `.leading` or `.trailing` push the group toward
  /// that edge on a wider button.
  public func contentAlignment(_ alignment: HorizontalAlignment) -> some View {
    environment(\.textButtonContentAlignment, alignment)
  }

  /// Sets the gap between a Text Button's icon and text.
  public func contentSpacing(_ spacing: CGFloat) -> some View {
    environment(\.textButtonContentSpacing, spacing)
  }

  /// Sets the horizontal inset between a Text Button's edge and its
  /// icon+text content — visible as margin when the icon sits at the
  /// leading or trailing edge.
  public func contentPadding(_ padding: CGFloat) -> some View {
    environment(\.textButtonContentPadding, padding)
  }

  /// Sets an explicit icon+text size for Text Buttons beneath this view,
  /// overriding the default of `CustomButtonConfiguration.iconSize(for:)`.
  /// Pass `nil` to reset back to that tied-to-size default.
  public func fontSize(_ size: CGFloat?) -> some View {
    environment(\.textButtonFontSizeOverride, size)
  }
}
