import Foundation
import Extensions

/// A structure representing an RGB color with red, green, and blue components.
/// Each component is an integer value between 0 and 255.
public struct RGB: Identifiable, Hashable, Sendable {

  // MARK: Private Properties

  // Private variables to hold the true values of red, green, and blue
  private var _rValue: Double = 0.0
  private var _gValue: Double = 0.0
  private var _bValue: Double = 0.0

  // MARK: Properties

  /// A unique identifier for the RGB instance.
  public let id = UUID()

  /// The red component of the color (0.0-1.0).
  public var rValue: Double {
    get { _rValue }
    set {
      _rValue = newValue.normalized()
    }
  }
  /// The green component of the color (0.0-1.0).
  public var gValue: Double {
    get { _gValue }
    set {
      _gValue = newValue.normalized()
    }
  }
  /// The blue component of the color (0.0-1.0).
  public var bValue: Double {
    get { _bValue }
    set {
      _bValue = newValue.normalized()
    }
  }

  /// The red component of the color (0-255).
  /// Note: This is approximate Integer value based on the rValue.
  public var r: Int {
    get { Int((_rValue * 255.0).rounded()) }
    set {
      let red = RGB.validRange.clamp(newValue)
      _rValue = Double(red) / 255.0
    }
  }
  /// The red component of the color (0-255).
  /// Note: This is approximate Integer value based on the gValue.
  public var g: Int {
    get { Int((_gValue * 255.0).rounded()) }
    set {
      let green = RGB.validRange.clamp(newValue)
      _gValue = Double(green) / 255.0
    }
  }
  /// The blue component of the color (0-255).
  /// Note: This is approximate Integer value based on the bValue.
  public var b: Int {
    get { Int((_bValue * 255.0).rounded()) }
    set {
      let blue = RGB.validRange.clamp(newValue)
      _bValue = Double(blue) / 255.0
    }
  }

  // MARK: Helper Properties

  /// Provides a description of the RGB color.
  ///
  /// - Returns: A String detailing the red, green, and blue values as "RGB(##, ##, ##)".
  public var description: String {
    "RGB(\(r), \(g), \(b))"
  }

  /// Checks the visual perception of the Color (WCAG relative luminance).
  ///
  /// - Returns:`true` if the color is perceptually light.
  var isLight: Bool {
    func linearise(_ value: Double) -> Double {
      value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
    }
    let luminance = 0.2126 * linearise(rValue)
    + 0.7152 * linearise(gValue)
    + 0.0722 * linearise(bValue)
    return luminance > 0.179
  }

  // MARK: Initializers

  /// Initializes an RGB color to black (r: 0, g: 0, b: 0).
  init() { }

  /// Initializes an RGB color with specified red, green, and blue Integer values.
  ///
  /// - Parameters:
  ///   - r: The red component (0-255).
  ///   - g: The green component (0-255).
  ///   - b: The blue component (0-255).
  /// - Note: Values outside the range 0-255 are clamped to the nearest valid value.
  init(r: Int, g: Int, b: Int) {
    self.r = r
    self.g = g
    self.b = b
  }

  /// Initializes an RGB color with specified red, green, and blue Double values.
  ///
  /// - Parameters:
  ///   - r: The red component (0.0-1.0).
  ///   - g: The green component (0.0-1.0).
  ///   - b: The blue component (0.0-1.0).
  /// - Note: Values outside the range 0.0-1.0 are clamped between 0.0 and 1.0.
  init(r: Double, g: Double, b: Double) {
    self.rValue = r
    self.gValue = g
    self.bValue = b
  }

  /// Initializes an RGB color with the same value for red, green, and blue components.
  /// This is used to create black and white tones.
  ///
  /// - Parameters:
  ///   - value: The Integer value for all three components (0-255).
  init(value: Int) {
    let clampedValue = RGB.validRange.clamp(value)
    self.init(r: clampedValue, g: clampedValue, b: clampedValue)
  }

  /// Initializes an RGB color with the same value for red, green, and blue components.
  /// This is used to create black and white tones.
  ///
  /// - Parameters:
  ///   - value: The Double value for all three components (0.0-1.0).
  init(value: Double) {
    let normalizedValue = value.normalized()
    self.init(r: normalizedValue, g: normalizedValue, b: normalizedValue)
  }
}

extension RGB {

  // MARK: Additional Initializers

  /// Initializes an `RGB` instance from a `Hex` object.
  ///
  /// - Parameters:
  ///   - hex: A `Hex` instance representing the hexadecimal color code.
  public init(hex: Hex) {
    // Extract the r, g, b values from the hex object to create an RGB
    self.init(r: hex.r, g: hex.g, b: hex.b)
  }

  /// Initializes an `RGB` instance from a hexadecimal color code string.
  ///
  /// - Parameters:
  ///   - hex: A string representing the hexadecimal color code.
  public init(hex code: String) {
    // Create a Hex object and then call the above initializer
    self.init(hex: Hex(code))
  }

  // MARK: Methods

  /// Converts an `RGB` instance to an `HSL` instance.
  ///
  /// - Returns: An `HSL` instance representing the same color.
  public func toHSL() -> HSL {

    // Find the maximum and minimum values among the RGB components
    let maxValue = Swift.max(rValue, gValue, bValue)
    let minValue = Swift.min(rValue, gValue, bValue)
    let delta = maxValue - minValue // Difference between max and min

    var hue: Double = 0.0 // Hue
    var saturation: Double = 0.0 // Saturation
    let lightness = (maxValue + minValue) / 2.0 // Lightness is the average of max and min

    // If the color is not grayscale (delta != 0), calculate hue and saturation
    if delta != 0 {
      // Calculate saturation based on lightness
      saturation = lightness > 0.5 ? delta / (2.0 - maxValue - minValue) : delta / (maxValue + minValue)

      // Calculate hue based on which RGB component is the maximum
      if maxValue == rValue {
        hue = (gValue - bValue) / delta + (gValue < bValue ? 6.0 : 0.0)
      }
      else if maxValue == gValue {
        hue = (bValue - rValue) / delta + 2.0
      }
      else if maxValue == bValue {
        hue = (rValue - gValue) / delta + 4.0
      }
      hue /= 6.0 // Normalize hue to the range between 0.0 and 1.0
    }

    // Return the HSL representation
    return HSL(h: hue, s: saturation, l: lightness)
  }

  /// Converts an `RGB` instance to an `HSB` instance.
  ///
  /// - Returns: An `HSB` instance representing the same color.
  public func toHSB() -> HSB {
    let maxValue = Swift.max(rValue, gValue, bValue)
    let minValue = Swift.min(rValue, gValue, bValue)
    let delta    = maxValue - minValue

    let brightness = maxValue

    // Achromatic case
    guard delta > 0 else {
      return HSB(h: 0, s: 0, b: brightness)
    }

    let saturation = delta / maxValue

    // Calculate hue
    var hue: Double
    if maxValue == rValue {
      hue = (gValue - bValue) / delta + (gValue < bValue ? 6.0 : 0.0)
    }
    else if maxValue == gValue {
      hue = (bValue - rValue) / delta + 2.0
    }
    else {
      hue = (rValue - gValue) / delta + 4.0
    }
    hue /= 6.0 // Normalise to 0.0-1.0

    return HSB(h: hue, s: saturation, b: brightness)
  }

  // MARK: Color Mixer

  /// Calculates an `RGB` value between two colors based on a percentage.
  ///
  /// - Parameters:
  ///   - color1: The first `RGB` color.
  ///   - color2: The second `RGB` color.
  ///   - percent: The percentage (0.0-1.0) to mix the colors.
  /// - Returns: An `RGB` color that is a mix of the two colors.
  public static func mix(_ color1: RGB, with color2: RGB, percent: Double = 0.5) -> RGB {

    func mixOf(_ value1: Double, with value2: Double) -> Double {
      let portionOfValue1 = (1 - percent) * value1
      let portionOfValue2 = percent * value2
      return portionOfValue1 + portionOfValue2
    }
    return RGB(
      r: mixOf(color1.rValue, with: color2.rValue),
      g: mixOf(color1.gValue, with: color2.gValue),
      b: mixOf(color1.bValue, with: color2.bValue)
    )
  }

  /// Generates an array of `RGB` values between two colors, evenly distributed.
  ///
  /// - Parameters:
  ///   - rgb1: The starting `RGB` color.
  ///   - rgb2: The ending `RGB` color.
  ///   - count: The number of gradient colors to generate.
  ///   - includingOriginals: Whether to include the original colors in the result.
  /// - Returns: An array of `RGB` colors representing the gradient.
  public static func gradients(between rgb1: RGB, and rgb2: RGB, count: Int, includingOriginals: Bool = true) -> [RGB] {
    // Check for a valid count
    if includingOriginals && count <= 2 {
      return [rgb1, rgb2]
    }
    if count <= 0 { return [] }

    // Check for identical colors
    if rgb1.rValue == rgb2.rValue && rgb1.gValue == rgb2.gValue && rgb1.bValue == rgb2.bValue {
      return Array(repeating: rgb1, count: count)
    }

    var gradientList = [RGB]()
    let percentIncrement = 1.0 / Double(count + 1)
    for index in 1...count {
      let percent = percentIncrement * Double(index)
      gradientList.append(mix(rgb1, with: rgb2, percent: percent))
    }
    if includingOriginals {
      gradientList.insert(rgb1, at: 0)
      gradientList.append(rgb2)
    }
    return gradientList
  }
}
