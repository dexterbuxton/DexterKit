import Foundation

public extension BinaryFloatingPoint {
  /// Returns a string value of the number with only 2 decimal places
  var shortened: String {
    return String(format: "%.2f", Double(self))
  }

  /// This will clamp a value ensuring it falls within the range of 0 to 1 (useful for percent ranges)
  func normalized() -> Self {
      return (0...1).clamp(self)
  }
}
