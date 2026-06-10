import Foundation

/// A structure representing a hexadecimal color code.
/// The code must contain characters ranging from 0-9 and A-F.
/// All characters in the code will be uppercased after initialization.
public struct Hex: Identifiable, Hashable, Sendable {

  // MARK: Private Properties

  private var _code = fallbackCode

  // MARK: Properties

  /// A unique identifier for the Hex instance.
  public let id = UUID()

  /// The hexadecimal color code as a string.
  /// - Note: Must be exactly 6 valid characters (0-9, A-F); otherwise falls back to `"000000"`.
  public var code: String {
    get { _code }
    set {
      let sanitizedCode = newValue.replacingOccurrences(of: "#", with: "")
      let uppercasedCode = sanitizedCode.uppercased()

      if uppercasedCode.count != 6 {
        _code = Hex.fallbackCode
      }
      else if uppercasedCode.allSatisfy({ character in
        Hex.validCharacters.contains(character)
      }) {
        _code = uppercasedCode
      }
      else {
        _code = Hex.fallbackCode
      }
    }
  }

  /// The red component of the hexadecimal color code (0-255).
  public var r: Int {
    let hexCodeArray = Array(code)
    return String(hexCodeArray[0...1]).hexadecimalToInt
  }

  /// The green component of the hexadecimal color code (0-255).
  public var g: Int {
    let hexCodeArray = Array(code)
    return String(hexCodeArray[2...3]).hexadecimalToInt
  }

  /// The blue component of the hexadecimal color code (0-255).
  public var b: Int {
    let hexCodeArray = Array(code)
    return String(hexCodeArray[4...5]).hexadecimalToInt
  }

  // MARK: Description

  /// Provides a description of the Hex color in the format `"#XXXXXX"`.
  public var description: String {
    "#\(code)"
  }

  /// Whether the color is perceptually light (WCAG relative luminance).
  public var isLight: Bool { RGB(hex: self).isLight }

  // MARK: Initializer

  /// Initializes a `Hex` instance with a given hexadecimal color code.
  /// - Note: If the provided code is invalid, it falls back to `"000000"`.
  public init(_ code: String = Hex.fallbackCode) {
    self.code = code
  }

  // MARK: Methods

  /// Returns a random `Hex` color.
  public static var random: Hex {
    let code = (0..<6).compactMap { _ in validCharacters.randomElement().map(String.init) }.joined()
    return Hex(code)
  }

  // MARK: Static Variables

  /// A fallback hexadecimal color code used for invalid inputs.
  public static let fallbackCode = "000000"
  /// A set of valid characters for hexadecimal color codes.
  public static let validCharacters = "0123456789ABCDEF"

  // Basic Colors
  public static let black   = Hex("000000")
  public static let white   = Hex("FFFFFF")
  public static let red     = Hex("FF0000")
  public static let green   = Hex("00FF00")
  public static let blue    = Hex("0000FF")
  public static let cyan    = Hex("00FFFF")
  public static let magenta = Hex("FF00FF")
  public static let yellow  = Hex("FFFF00")
}

extension Hex {

  // MARK: Additional Initializers

  /// Initializes a `Hex` instance from an `RGB` instance.
  public init(rgb: RGB) {
    func hexFrom(_ value: Int) -> String {
      let hex = value.hexadecimalString
      return hex.count == 2 ? hex : "0" + hex
    }
    let hexCode = String(hexFrom(rgb.r) + hexFrom(rgb.g) + hexFrom(rgb.b))
    self.init(hexCode)
  }

  /// Initializes a `Hex` instance from individual red, green, and blue components (0-255).
  public init(r: Int, g: Int, b: Int) {
    self.init(rgb: RGB(r: r, g: g, b: b))
  }

  // MARK: Methods

  /// Converts a `Hex` instance to an `HSL` instance.
  public func toHSL() -> HSL {
    RGB(hex: self).toHSL()
  }

  /// Converts a `Hex` instance to an `HSB` instance.
  public func toHSB() -> HSB {
    RGB(hex: self).toHSB()
  }
}
