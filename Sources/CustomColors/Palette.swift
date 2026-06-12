import SwiftUI
import Extensions

/// A named, ordered collection of colors.
///
/// A `Palette` holds a list of `Palette.Element` values — each a single color in
/// any supported representation (`Hex`, `RGB`, or `HSB`), optionally labeled with
/// a name and optionally carrying a dark-mode variant. It is a value type and
/// safe to pass across concurrency boundaries.
public struct Palette: Identifiable, Hashable, Sendable {

  /// A single color entry: a color in any representation, optionally named, with
  /// an optional dark-mode variant.
  public struct Element: Identifiable, Hashable, Sendable {

    // swiftlint:disable nesting
    /// The underlying color representation an entry can hold.
    public enum Value: Hashable, Sendable {
      case hex(Hex)
      case rgb(RGB)
      case hsb(HSB)

      // MARK: Conversions

      /// The `Hex` representation, converting if necessary.
      public var hexValue: Hex {
        switch self {
        case .hex(let hex): hex
        case .rgb(let rgb): Hex(rgb: rgb)
        case .hsb(let hsb): hsb.toHex()
        }
      }

      /// The `RGB` representation, converting if necessary.
      public var rgbValue: RGB {
        switch self {
        case .hex(let hex): RGB(hex: hex)
        case .rgb(let rgb): rgb
        case .hsb(let hsb): hsb.toRGB()
        }
      }

      /// The `HSB` representation, converting if necessary.
      public var hsbValue: HSB {
        switch self {
        case .hex(let hex): HSB(hex: hex)
        case .rgb(let rgb): HSB(rgb: rgb)
        case .hsb(let hsb): hsb
        }
      }
    }
    // swiftlint:enable nesting

    // MARK: Properties

    /// A unique identifier for this entry.
    public let id: UUID

    /// An optional label for the color (e.g. "Red", "Lime").
    public var name: String?

    /// The color value — used as the light/default appearance.
    public var value: Value

    /// An optional dark-mode override. When `nil`, `value` is used in both schemes.
    public var dark: Value?

    // MARK: Initializers

    public init(id: UUID = UUID(), name: String? = nil, value: Value, dark: Value? = nil) {
      self.id = id
      self.name = name
      self.value = value
      self.dark = dark
    }

    /// Creates an entry from a `Hex` color, with an optional dark `Hex`.
    public init(name: String? = nil, hex: Hex, dark: Hex? = nil) {
      self.init(name: name, value: .hex(hex), dark: dark.map(Value.hex))
    }

    /// Creates an entry from an `RGB` color, with an optional dark `RGB`.
    public init(name: String? = nil, rgb: RGB, dark: RGB? = nil) {
      self.init(name: name, value: .rgb(rgb), dark: dark.map(Value.rgb))
    }

    /// Creates an entry from an `HSB` color, with an optional dark `HSB`.
    public init(name: String? = nil, hsb: HSB, dark: HSB? = nil) {
      self.init(name: name, value: .hsb(hsb), dark: dark.map(Value.hsb))
    }

    // MARK: Conversions (light / default)

    /// The `Hex` representation of the light/default value.
    public var hexValue: Hex { value.hexValue }

    /// The `RGB` representation of the light/default value.
    public var rgbValue: RGB { value.rgbValue }

    /// The `HSB` representation of the light/default value.
    public var hsbValue: HSB { value.hsbValue }

    /// A display label: the `name` if set, otherwise the hex description.
    public var description: String {
      name ?? hexValue.description
    }
  }

  // MARK: Properties

  /// A unique identifier for this palette.
  public let id: UUID

  /// A human-readable name for the palette.
  public var name: String

  /// The ordered list of color entries.
  public private(set) var entries: [Element]

  /// The number of colors currently in the palette.
  public var count: Int { entries.count }

  /// Returns `true` when the palette contains no colors.
  public var isEmpty: Bool { entries.isEmpty }

  // MARK: Initialization

  /// Creates a new `Palette` with an optional name and initial entries.
  public init(name: String = "Untitled", entries: [Element] = []) {
    self.id = UUID()
    self.name = name
    self.entries = entries
  }

  // MARK: Add

  /// Appends an entry.
  public mutating func add(_ entry: Element) {
    entries.append(entry)
  }

  /// Appends a `Hex` color, optionally named and with an optional dark variant.
  public mutating func add(_ hex: Hex, name: String? = nil, dark: Hex? = nil) {
    add(Element(name: name, hex: hex, dark: dark))
  }

  /// Appends an `RGB` color, optionally named and with an optional dark variant.
  public mutating func add(_ rgb: RGB, name: String? = nil, dark: RGB? = nil) {
    add(Element(name: name, rgb: rgb, dark: dark))
  }

  /// Appends an `HSB` color, optionally named and with an optional dark variant.
  public mutating func add(_ hsb: HSB, name: String? = nil, dark: HSB? = nil) {
    add(Element(name: name, hsb: hsb, dark: dark))
  }

  /// Inserts an entry at an index, clamped to valid bounds.
  public mutating func insert(_ entry: Element, at index: Int) {
    let safeIndex = (0...entries.count).clamp(index)
    entries.insert(entry, at: safeIndex)
  }

  // MARK: Remove

  /// Removes the entry with the given `id`.
  /// - Returns: The removed entry, or `nil` if no match was found.
  @discardableResult
  public mutating func remove(id: Element.ID) -> Element? {
    guard let index = entries.firstIndex(where: { $0.id == id }) else { return nil }
    return entries.remove(at: index)
  }

  /// Removes the entry at a specific index.
  /// - Returns: The removed entry, or `nil` if the index is out of bounds.
  @discardableResult
  public mutating func remove(at index: Int) -> Element? {
    guard entries.indices.contains(index) else { return nil }
    return entries.remove(at: index)
  }

  /// Removes all entries.
  public mutating func removeAll() {
    entries.removeAll()
  }

  // MARK: Reorder

  /// Moves entries to a new offset. Designed for SwiftUI `List` `onMove`.
  public mutating func move(fromOffsets source: IndexSet, toOffset destination: Int) {
    entries.move(fromOffsets: source, toOffset: destination)
  }

  /// Returns a copy with entries in reverse order.
  public func reversed() -> Palette {
    Palette(name: name, entries: entries.reversed())
  }
}
