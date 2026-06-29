import SwiftUI

// MARK: Icon Representable

/// A symbol identity: an SF Symbol name and an accessibility label.
///
/// This is the extension seam for the icon-button system. `IconType` is the
/// batteries-included conformer that ships with DexterKit, but any type —
/// typically a small app-defined `enum` — can conform to supply its own symbols
/// and flow through the exact same buttons:
///
/// ```swift
/// enum AppIcon: IconRepresentable {
///   case sparkle
///   var symbolName: String? {
///     switch self {
///     case .sparkle: "sparkles"
///     }
///   }
///   var accessibilityLabel: String {
///     switch self {
///     case .sparkle: "Sparkle"
///     }
///   }
/// }
///
/// IconButton(AppIcon.sparkle, action: {})
/// ```
///
/// `symbolName` is optional: `nil` renders nothing. That is how `EmptyIcon`
/// expresses an empty slot — for instance the "off" symbol of an
/// `IconToggleButton` that fades a single icon in and out.
///
/// Identity only. Color, size, and weight are rendering concerns supplied at the
/// call site or by the `IconButtonTheme` — never carried on the symbol itself.
public protocol IconRepresentable: Sendable {

  /// The SF Symbol name to render, or `nil` to render nothing.
  var symbolName: String? { get }

  /// The VoiceOver label for this symbol.
  var accessibilityLabel: String { get }
}

// MARK: Icon Type Conformance

extension IconType: IconRepresentable {

  /// Bridges the catalog's non-optional `systemImage` to the protocol. `IconType`
  /// always has a symbol, so this never returns `nil`.
  public var symbolName: String? { systemImage }
}

// MARK: Empty Icon

/// A symbol that renders nothing.
///
/// Use as the "off" symbol of an `IconToggleButton` to fade a single icon in and
/// out (the pattern behind `IconToggleButton.indicator`), or anywhere a slot
/// must hold an `IconRepresentable` but show no symbol.
public struct EmptyIcon: IconRepresentable {

  public var symbolName: String? { nil }
  public var accessibilityLabel: String { "" }

  public init() {}
}

public extension IconRepresentable where Self == EmptyIcon {

  /// A symbol that renders nothing.
  static var empty: EmptyIcon { EmptyIcon() }
}

// MARK: Filled Dot

/// A filled-circle symbol — the in-system stand-in for the swatch dot that
/// `IconToggleButton.indicator` fades in and out.
public struct FilledDotIcon: IconRepresentable {

  public var symbolName: String? { "circle.fill" }
  public var accessibilityLabel: String { "Selected" }

  public init() {}
}

public extension IconRepresentable where Self == FilledDotIcon {

  /// A filled-circle symbol.
  static var filledDot: FilledDotIcon { FilledDotIcon() }
}
