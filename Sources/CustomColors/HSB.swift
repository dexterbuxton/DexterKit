import Foundation
import Extensions

/// A structure representing an HSB (Hue, Saturation, Brightness) color.
public struct HSB: Identifiable, Hashable, Sendable {

  // MARK: Private Properties

  // Private variables to hold the true values of hue, saturation, and brightness
  private var _hValue: Double = 0.0
  private var _sValue: Double = 0.0
  private var _bValue: Double = 0.0

  // MARK: Properties

  /// A unique identifier for the HSB instance.
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

  /// The Brightness percentage of the color (Double between 0.0-1.0).
  public var bValue: Double {
    get { _bValue }
    set { _bValue = newValue.normalized() }
  }

  /// The Hue of the color representing a degree (Integer between 0-360).
  /// Note: This is an approximate Integer value based on hValue.
  public var h: Int {
    get { Int((_hValue * 360).rounded()) }
    set {
      let hue = (0...360).clamp(newValue)
      _hValue = Double(hue) / 360
    }
  }

  /// The Saturation of the color representing a percentage (Integer between 0-100).
  /// Note: This is an approximate Integer value based on sValue.
  public var s: Int {
    get { Int((_sValue * 100).rounded()) }
    set {
      let saturation = (0...100).clamp(newValue)
      _sValue = Double(saturation) / 100.0
    }
  }

  /// The Brightness of the color representing a percentage (Integer between 0-100).
  /// Note: This is an approximate Integer value based on bValue.
  public var b: Int {
    get { Int((_bValue * 100).rounded()) }
    set {
      let brightness = (0...100).clamp(newValue)
      _bValue = Double(brightness) / 100.0
    }
  }

  /// Provides a description of the HSB color.
  ///
  /// - Returns: A String detailing the hue, saturation, and brightness
  ///   values as "HSB(##, ##%, ##%)".
  public var description: String {
    return "HSB(\(h), \(s)%, \(b)%)"
  }

  // MARK: Initializers

  /// Initializes an HSB color to black (h: 0, s: 0, b: 0).
  public init() { }

  /// Initializes an HSB color with specified hue, saturation, and brightness Integer values.
  ///
  /// - Parameters:
  ///   - h: The hue component (0-360).
  ///   - s: The saturation component (0-100).
  ///   - b: The brightness component (0-100).
  /// - Note: Values outside the range are clamped to the nearest valid value.
  public init(h: Int, s: Int, b: Int) {
    self.h = h
    self.s = s
    self.b = b
  }

  /// Initializes an HSB color with specified hue, saturation, and brightness Double values.
  ///
  /// - Parameters:
  ///   - h: The hue component (0.0-1.0).
  ///   - s: The saturation component (0.0-1.0).
  ///   - b: The brightness component (0.0-1.0).
  /// - Note: Values outside the range are clamped to the nearest valid value.
  public init(h: Double, s: Double, b: Double) {
    self.hValue = h
    self.sValue = s
    self.bValue = b
  }

  // MARK: Static Properties

  public static let black     = HSB(h: 0, s: 0, b: 0)
  public static let white     = HSB(h: 0, s: 0, b: 100)
  public static let red       = HSB(h: 0, s: 100, b: 100)
  public static let green     = HSB(h: 120, s: 100, b: 100)
  public static let blue      = HSB(h: 240, s: 100, b: 100)
  public static let cyan      = HSB(h: 180, s: 100, b: 100)
  public static let magenta   = HSB(h: 300, s: 100, b: 100)
  public static let yellow    = HSB(h: 60, s: 100, b: 100)
  public static let gray      = HSB(h: 0, s: 0, b: 50)
  public static let lightGray = HSB(h: 0, s: 0, b: 75)
  public static let darkGray  = HSB(h: 0, s: 0, b: 25)
  public static let orange    = HSB(h: 30, s: 100, b: 100)
  public static let purple    = HSB(h: 270, s: 100, b: 100)
  public static let pink      = HSB(h: 350, s: 25, b: 100)
  public static let brown     = HSB(h: 30, s: 100, b: 40)
}

extension HSB {

  // MARK: Additional Initializers

  /// Initializes an `HSB` instance from an `RGB` instance.
  ///
  /// - Parameter rgb: An `RGB` instance representing the red, green, and blue components.
  public init(rgb: RGB) {
    let hsb = rgb.toHSB()
    self.init(h: hsb.hValue, s: hsb.sValue, b: hsb.bValue)
  }

  /// Initializes an `HSB` instance from red, green, and blue values as `Double` (0.0-1.0).
  public init(r: Double, g: Double, b: Double) {
    let rgb = RGB(r: r, g: g, b: b)
    self.init(rgb: rgb)
  }

  /// Initializes an `HSB` instance from red, green, and blue values as `Int` (0-255).
  public init(r: Int, g: Int, b: Int) {
    let rgb = RGB(r: r, g: g, b: b)
    self.init(rgb: rgb)
  }

  /// Initializes an `HSB` instance from a `Hex` object.
  public init(hex: Hex) {
    self.init(rgb: RGB(hex: hex))
  }

  /// Initializes an `HSB` instance from a hexadecimal color code string.
  public init(hexCode: String) {
    let hex = Hex(hexCode)
    self.init(rgb: RGB(hex: hex))
  }

  // MARK: Methods

  /// Converts an `HSB` instance to an `RGB` instance.
  ///
  /// - Returns: An `RGB` instance representing the same color.
  public func toRGB() -> RGB {
    let h = hValue // Hue (0.0-1.0)
    let s = sValue // Saturation (0.0-1.0)
    let b = bValue // Brightness (0.0-1.0)

    // Achromatic case: no saturation means a grey tone
    guard s > 0 else {
      return RGB(r: b, g: b, b: b)
    }

    // Sector of the colour wheel (0-5)
    let hScaled = h * 6.0
    let sector = Int(hScaled) % 6
    let hueFraction = hScaled - Double(Int(hScaled)) // Fractional part

    let dimmed = b * (1 - s)
    let fadingOut = b * (1 - s * hueFraction)
    let fadingIn = b * (1 - s * (1 - hueFraction))

    switch sector {
    case 0: return RGB(r: b, g: fadingIn, b: dimmed)
    case 1: return RGB(r: fadingOut, g: b, b: dimmed)
    case 2: return RGB(r: dimmed, g: b, b: fadingIn)
    case 3: return RGB(r: dimmed, g: fadingOut, b: b)
    case 4: return RGB(r: fadingIn, g: dimmed, b: b)
    default: return RGB(r: b, g: dimmed, b: fadingOut) // case 5
    }
  }

  /// Converts an `HSB` instance to a `Hex` instance.
  ///
  /// - Returns: A `Hex` instance representing the same color.
  public func toHex() -> Hex {
    return Hex(rgb: self.toRGB())
  }
}
