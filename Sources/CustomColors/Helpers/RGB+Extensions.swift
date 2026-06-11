import Foundation

public extension RGB {

  // MARK: Methods

  /// Generates a random RGB color with red, green, and blue values between 0 and 255.
  ///
  /// - Returns: A randomly generated `RGB` instance.
  static var random: RGB {
    // Generate Random RGB Values between 0 and 255
    return RGB(
      r: .random(in: validRange),
      g: .random(in: validRange),
      b: .random(in: validRange)
    )
  }

  // MARK: Static Variables

  static let validRange = RGB.min...RGB.max
  private static let min: Int = 0
  private static let max: Int = 255

  // Basic Colors
  static let black   = RGB()
  static let white   = RGB(value: max)
  static let red     = RGB(r: max, g: min, b: min)
  static let green   = RGB(r: min, g: max, b: min)
  static let blue    = RGB(r: min, g: min, b: max)
  static let cyan    = RGB(r: min, g: max, b: max)
  static let magenta = RGB(r: max, g: min, b: max)
  static let yellow  = RGB(r: max, g: max, b: min)

  // Grays
  static let gray = RGB(value: 127)
  static let lightGray: RGB  = RGB(value: 170)
  static let darkGray = RGB(value: 85)

  // Visual Colors
  static let offBlack: RGB = RGB(value: 30)
  static let offWhite = RGB(value: 240)

  /// 75 Vibrant RGB values with a distinct visible hue difference
  static let colors: [RGB] = [
    RGB(r: 255, g: 0, b: 0), // Red
    RGB(r: 255, g: 50, b: 0),
    RGB(r: 255, g: 75, b: 0),
    RGB(r: 255, g: 90, b: 0),
    RGB(r: 255, g: 105, b: 0),
    RGB(r: 255, g: 120, b: 0),
    RGB(r: 255, g: 135, b: 0),
    RGB(r: 255, g: 145, b: 0),
    RGB(r: 255, g: 155, b: 0),
    RGB(r: 255, g: 165, b: 0),
    RGB(r: 255, g: 175, b: 0),
    RGB(r: 255, g: 183, b: 0),
    RGB(r: 255, g: 191, b: 0),
    RGB(r: 255, g: 199, b: 0),
    RGB(r: 255, g: 207, b: 0),
    RGB(r: 255, g: 215, b: 0),
    RGB(r: 255, g: 221, b: 0),
    RGB(r: 255, g: 227, b: 0),
    RGB(r: 255, g: 233, b: 0),
    RGB(r: 255, g: 239, b: 0),
    RGB(r: 255, g: 245, b: 0),
    RGB(r: 255, g: 250, b: 0),
    RGB(r: 255, g: 255, b: 0), // Yellow
    RGB(r: 240, g: 255, b: 0),
    RGB(r: 225, g: 255, b: 0),
    RGB(r: 210, g: 255, b: 0),
    RGB(r: 190, g: 255, b: 0),
    RGB(r: 170, g: 255, b: 0),
    RGB(r: 135, g: 255, b: 0),
    RGB(r: 100, g: 255, b: 0),
    RGB(r: 0, g: 255, b: 0), // Green
    RGB(r: 0, g: 255, b: 120),
    RGB(r: 0, g: 255, b: 160),
    RGB(r: 0, g: 255, b: 195),
    RGB(r: 0, g: 255, b: 225),
    RGB(r: 0, g: 255, b: 255), // Cyan
    RGB(r: 0, g: 248, b: 255),
    RGB(r: 0, g: 241, b: 255),
    RGB(r: 0, g: 234, b: 255),
    RGB(r: 0, g: 227, b: 255),
    RGB(r: 0, g: 220, b: 255),
    RGB(r: 0, g: 213, b: 255),
    RGB(r: 0, g: 206, b: 255),
    RGB(r: 0, g: 199, b: 255),
    RGB(r: 0, g: 192, b: 255),
    RGB(r: 0, g: 185, b: 255),
    RGB(r: 0, g: 178, b: 255),
    RGB(r: 0, g: 171, b: 255),
    RGB(r: 0, g: 164, b: 255),
    RGB(r: 0, g: 155, b: 255),
    RGB(r: 0, g: 145, b: 255),
    RGB(r: 0, g: 130, b: 255),
    RGB(r: 0, g: 115, b: 255),
    RGB(r: 0, g: 100, b: 255),
    RGB(r: 0, g: 85, b: 255),
    RGB(r: 0, g: 70, b: 255),
    RGB(r: 0, g: 50, b: 255),
    RGB(r: 0, g: 0, b: 255), // Blue
    RGB(r: 80, g: 0, b: 255),
    RGB(r: 110, g: 0, b: 255),
    RGB(r: 135, g: 0, b: 255),
    RGB(r: 150, g: 0, b: 255),
    RGB(r: 165, g: 0, b: 255),
    RGB(r: 180, g: 0, b: 255),
    RGB(r: 195, g: 0, b: 255),
    RGB(r: 205, g: 0, b: 255),
    RGB(r: 215, g: 0, b: 255),
    RGB(r: 225, g: 0, b: 255),
    RGB(r: 235, g: 0, b: 255),
    RGB(r: 245, g: 0, b: 255),
    RGB(r: 255, g: 0, b: 255), // Magenta
    RGB(r: 255, g: 0, b: 220),
    RGB(r: 255, g: 0, b: 180),
    RGB(r: 255, g: 0, b: 150),
    RGB(r: 255, g: 0, b: 100)]

  /// 30 Visually distinct tones (Black, Gray, and White White colors)
  static let tones: [RGB]  = [
    RGB(value: 0),
    RGB(value: 30),
    RGB(value: 50),
    RGB(value: 64),
    RGB(value: 71),
    RGB(value: 79),
    RGB(value: 87),
    RGB(value: 95),
    RGB(value: 103),
    RGB(value: 111),
    RGB(value: 119),
    RGB(value: 127),
    RGB(value: 135),
    RGB(value: 143),
    RGB(value: 151),
    RGB(value: 159),
    RGB(value: 168),
    RGB(value: 177),
    RGB(value: 186),
    RGB(value: 195),
    RGB(value: 204),
    RGB(value: 211),
    RGB(value: 217),
    RGB(value: 223),
    RGB(value: 229),
    RGB(value: 235),
    RGB(value: 240),
    RGB(value: 245),
    RGB(value: 250),
    RGB(value: 255)
  ]
}
