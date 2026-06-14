import SwiftUI

public extension Palette {

  /// The element whose name (case-insensitive) or hex code matches `string`,
  /// or `nil` if the palette contains no match.
  ///
  /// Names are matched first, so a name that happens to look like a hex code
  /// still resolves as a name.
  func element(for string: String) -> Element? {
    if let named = entries.first(where: { $0.name?.caseInsensitiveCompare(string) == .orderedSame }) {
      return named
    }
    return entries.first { $0.hexValue.code.caseInsensitiveCompare(string) == .orderedSame }
  }

  /// The element with the given identifier, or `nil` if it isn't in this palette.
  ///
  /// Pairs with `element(for:)` to bridge a `PalettePicker`'s `Element.ID`
  /// selection back to a stored name or hex string.
  func element(id: Element.ID) -> Element? {
    entries.first { $0.id == id }
  }

  /// Resolves a name-or-hex string to a color, or `nil` if it's neither a known
  /// entry nor a valid hex code.
  ///
  /// - A known name or palette hex returns that entry's color (adaptive if the
  ///   entry has a `dark` variant).
  /// - An unrecognized but valid hex returns that flat color.
  /// - Anything else returns `nil`, leaving the fallback to the caller.
  ///
  /// ```swift
  /// Palette.material.color(for: "neutral")  // adaptive black/white
  /// Palette.material.color(for: "000000")   // flat black (not in the palette)
  /// Palette.material.color(for: "bogus")    // nil
  /// ```
  func color(for string: String) -> Color? {
    if let element = element(for: string) {
      return element.color
    }
    return Hex(validating: string)?.color
  }
}
