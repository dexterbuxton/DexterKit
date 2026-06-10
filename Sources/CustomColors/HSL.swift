import Foundation
import Extensions

/// A structure representing an HSL (Hue, Saturation, Lightness) color.
public struct HSL: Identifiable, Hashable, Sendable {

  // MARK: Private Properties

  private var _hValue: Double = 0.0
  private var _sValue: Double = 0.0
  private var _lValue: Double = 0.0

  // MARK: Properties

  /// A unique identifier for the HSL instance.
  public let id = UUID()

  /// The Hue percentage of the color (Double between 0.0-1.0).
  public var hValue: Double {
    get { _hValue }
    set { _hValue = newValue.normalized() }
  }

  /// The Saturation percentage of the color (Double between 0.0-1.0).
  public var sValue: Double {
    get { _sValue }
    set { _sValue = newValue.normalized() }
  }

  /// The Lightness percentage of the color (Double between 0.0-1.0).
  public var lValue: Double {
    get { _lValue }
    set { _lValue = newValue.normalized() }
  }

  /// The Hue of the color representing a degree (Integer between 0-360).
  /// - Note: This is an approximate Integer value based on `hValue`.
  public var h: Int {
    get { Int((_hValue * 360).rounded()) }
    set {
      let hue = (0...360).clamp(newValue)
      _hValue = Double(hue) / 360
    }
  }

  /// The Saturation of the color representing a percentage (Integer between 0-100).
  /// - Note: This is an approximate Integer value based on `sValue`.
  public var s: Int {
    get { Int((_sValue * 100).rounded()) }
    set {
      let saturation = (0...100).clamp(newValue)
      _sValue = Double(saturation) / 100.0
    }
  }

  /// The Lightness of the color representing a percentage (Integer between 0-100).
  /// - Note: This is an approximate Integer value based on `lValue`.
  public var l: Int {
    get { Int((_lValue * 100).rounded()) }
    set {
      let lightness = (0...100).clamp(newValue)
      _lValue = Double(lightness) / 100.0
    }
  }

  // MARK: Description

  /// Provides a description of the HSL color as "HSL(##, ##%, ##%)".
  public var description: String {
    "HSL(\(h), \(s)%, \(l)%)"
  }

  // MARK: Initializers

  /// Initializes an HSL color to black (h: 0, s: 0, l: 0).
  public init() { }

  /// Initializes an HSL color with Integer values (h: 0-360, s/l: 0-100).
  /// - Note: Values outside the range are clamped to the nearest valid value.
  public init(h: Int, s: Int, l: Int) {
    self.h = h
    self.s = s
    self.l = l
  }

  /// Initializes an HSL color with Double values (0.0-1.0).
  /// - Note: Values outside the range are clamped to the nearest valid value.
  public init(h: Double, s: Double, l: Double) {
    self.hValue = h
    self.sValue = s
    self.lValue = l
  }

  // MARK: Static Properties

  public static let black     = HSL(h: 0, s: 0, l: 0)
  public static let white     = HSL(h: 0, s: 0, l: 100)
  public static let red       = HSL(h: 0, s: 100, l: 50)
  public static let green     = HSL(h: 120, s: 100, l: 50)
  public static let blue      = HSL(h: 240, s: 100, l: 50)
  public static let cyan      = HSL(h: 180, s: 100, l: 50)
  public static let magenta   = HSL(h: 300, s: 100, l: 50)
  public static let yellow    = HSL(h: 60, s: 100, l: 50)
  public static let gray      = HSL(h: 0, s: 0, l: 50)
  public static let lightGray = HSL(h: 0, s: 0, l: 75)
  public static let darkGray  = HSL(h: 0, s: 0, l: 25)
  public static let orange    = HSL(h: 30, s: 100, l: 50)
  public static let purple    = HSL(h: 270, s: 100, l: 50)
  public static let pink      = HSL(h: 350, s: 100, l: 88)
  public static let brown     = HSL(h: 30, s: 100, l: 30)
}

extension HSL {

  // MARK: Additional Initializers

  /// Initializes an `HSL` instance from an `RGB` instance.
  public init(rgb: RGB) {
    let hsl = rgb.toHSL()
    self.init(h: hsl.hValue, s: hsl.sValue, l: hsl.lValue)
  }

  /// Initializes an `HSL` instance from red, green, and blue values as `Double` (0.0-1.0).
  public init(r: Double, g: Double, b: Double) {
    let rgb = RGB(r: r, g: g, b: b)
    self.init(rgb: rgb)
  }

  /// Initializes an `HSL` instance from red, green, and blue values as `Int` (0-255).
  public init(r: Int, g: Int, b: Int) {
    let rgb = RGB(r: r, g: g, b: b)
    self.init(rgb: rgb)
  }

  /// Initializes an `HSL` instance from a `Hex` object.
  public init(hex: Hex) {
    self.init(rgb: RGB(hex: hex))
  }

  /// Initializes an `HSL` instance from a hexadecimal color code string.
  public init(hexCode: String) {
    self.init(rgb: RGB(hex: Hex(hexCode)))
  }

  // MARK: Methods

  /// Converts an `HSL` instance to an `RGB` instance.
  public func toRGB() -> RGB {
    let h = hValue
    let s = sValue
    let l = lValue

    var r: Double = l
    var g: Double = l
    var b: Double = l

    if s != 0 {
      let chroma = l < 0.5 ? l * (1 + s) : l + s - l * s
      let secondary = 2 * l - chroma

      func hueToRGB(_ secondary: Double, _ chroma: Double, _ hueOffset: Double) -> Double {
        var hueOffset = hueOffset
        if hueOffset < 0 { hueOffset += 1 }
        if hueOffset > 1 { hueOffset -= 1 }
        if hueOffset < 1 / 6 { return secondary + (chroma - secondary) * 6 * hueOffset }
        if hueOffset < 1 / 2 { return chroma }
        if hueOffset < 2 / 3 { return secondary + (chroma - secondary) * (2 / 3 - hueOffset) * 6 }
        return secondary
      }

      r = hueToRGB(secondary, chroma, h + 1 / 3)
      g = hueToRGB(secondary, chroma, h)
      b = hueToRGB(secondary, chroma, h - 1 / 3)
    }

    return RGB(r: r, g: g, b: b)
  }

  /// Converts an `HSL` instance to a `Hex` instance.
  public func toHex() -> Hex {
    Hex(rgb: self.toRGB())
  }
}
