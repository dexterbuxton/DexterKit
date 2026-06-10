import SwiftUI

/// Converts an `RGB` value to a SwiftUI `Color`.
extension RGB {

  /// A SwiftUI `Color` built from the RGB components.
  public var color: Color {
    Color(red: rValue, green: gValue, blue: bValue)
  }
}

/// Converts a `Hex` value to a SwiftUI `Color`.
extension Hex {

  /// A SwiftUI `Color` built from the RGB values derived from the Hex code.
  public var color: Color {
    let rgb = RGB(hex: self.code)
    return Color(red: rgb.rValue, green: rgb.gValue, blue: rgb.bValue)
  }
}

/// Converts an `HSL` value to a SwiftUI `Color`.
extension HSL {

  /// A SwiftUI `Color` built from the HSL values (routed through RGB).
  public var color: Color {
    self.toRGB().color
  }
}

/// Converts an `HSB` value to a SwiftUI `Color`.
extension HSB {

  /// A SwiftUI `Color` built directly from the HSB values.
  public var color: Color {
    Color(hue: hValue, saturation: sValue, brightness: bValue)
  }
}
