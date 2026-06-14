import Foundation

/// A named, curated color backed by a `Hex` value.
///
/// `PaletteColor` is a fixed set of selectable colors intended for pickers and
/// persistence. Each case is backed by a `Hex`, so it bridges to `RGB`, `Hex`,
/// and SwiftUI `Color` exactly like the other color models — while remaining a
/// closed set with a stable `String` raw value for storage.
public enum PaletteColor: String, CaseIterable, Codable, Hashable, Sendable {

  case neutral
  case gray
  case pink
  case purple
  case deepPurple
  case indigo
  case blue
  case cyan
  case teal
  case green
  case lightGreen
  case lime
  case yellow
  case amber
  case orange
  case deepOrange
  case red

  // MARK: Color

  /// The hexadecimal color backing this palette entry.
  ///
  /// - Note: These are representative Material-500 values. Replace them with
  ///   your own asset-catalog hexes if they differ — `neutral` in particular
  ///   was an adaptive light/dark color, so pick the value you want it to be.
  public var hex: Hex {
    switch self {
    case .neutral:    Hex("8E8E93")
    case .gray:       Hex("9E9E9E")
    case .pink:       Hex("E91E63")
    case .purple:     Hex("9C27B0")
    case .deepPurple: Hex("673AB7")
    case .indigo:     Hex("3F51B5")
    case .blue:       Hex("2196F3")
    case .cyan:       Hex("00BCD4")
    case .teal:       Hex("009688")
    case .green:      Hex("4CAF50")
    case .lightGreen: Hex("8BC34A")
    case .lime:       Hex("CDDC39")
    case .yellow:     Hex("FFEB3B")
    case .amber:      Hex("FFC107")
    case .orange:     Hex("FF9800")
    case .deepOrange: Hex("FF5722")
    case .red:        Hex("F44336")
    }
  }

  /// The `RGB` representation, derived from `hex`.
  public var rgb: RGB { RGB(hex: hex) }

  /// Whether the color is perceptually light (delegates to `RGB`).
  public var isLight: Bool { rgb.isLight }

  // MARK: Description

  /// The display name shown in the UI.
  public var displayName: String {
    switch self {
    case .neutral:    "Neutral"
    case .gray:       "Gray"
    case .pink:       "Pink"
    case .purple:     "Purple"
    case .deepPurple: "Deep Purple"
    case .indigo:     "Indigo"
    case .blue:       "Blue"
    case .cyan:       "Cyan"
    case .teal:       "Teal"
    case .green:      "Green"
    case .lightGreen: "Light Green"
    case .lime:       "Lime"
    case .yellow:     "Yellow"
    case .amber:      "Amber"
    case .orange:     "Orange"
    case .deepOrange: "Deep Orange"
    case .red:        "Red"
    }
  }

  /// A human-readable description, matching the other color models.
  public var description: String { displayName }

  // MARK: Grid Order

  /// The display order for the 8×2 palette picker grid.
  ///
  /// - Note: 16 entries (neutral first, then the hue wheel); `pink` is omitted
  ///   to fit the 8×2 layout. All 17 cases remain available via `allCases`.
  public static let gridOrder: [PaletteColor] = [
    // Row 1
    .neutral, .purple, .red, .deepOrange, .orange, .amber, .yellow, .lime,
    // Row 2
    .gray, .deepPurple, .indigo, .blue, .cyan, .teal, .green, .lightGreen
  ]
}
