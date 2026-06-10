import Foundation

/// Hex/binary string conversions used by the color models.
public extension String {

  /// The integer value of a hexadecimal string (defaults to `0` if invalid).
  /// - Example: `"ff".hexadecimalToInt` returns `255`.
  var hexadecimalToInt: Int {
    Int(self, radix: 16) ?? 0
  }

  /// Converts a hexadecimal string to a binary string (defaults to `"0"` if invalid).
  /// - Example: `"ff".hexadecimalToBinary` returns `"11111111"`.
  var hexadecimalToBinary: String {
    String(hexadecimalToInt, radix: 2)
  }

  /// Converts an integer string to a hexadecimal string (defaults to `"0"` if invalid).
  /// - Example: `"255".intToHexadecimal` returns `"ff"`.
  var intToHexadecimal: String {
    guard let intValue = Int(self) else { return "0" }
    return String(intValue, radix: 16)
  }

  /// Converts an integer string to a binary string (defaults to `"0"` if invalid).
  /// - Example: `"255".intToBinary` returns `"11111111"`.
  var intToBinary: String {
    guard let intValue = Int(self) else { return "0" }
    return String(intValue, radix: 2)
  }

  /// The integer value of a binary string (defaults to `0` if invalid).
  /// - Example: `"11111111".binaryToInt` returns `255`.
  var binaryToInt: Int {
    Int(self, radix: 2) ?? 0
  }

  /// Converts a binary string to a hexadecimal string (defaults to `"0"` if invalid).
  /// - Example: `"11111111".binaryToHexadecimal` returns `"ff"`.
  var binaryToHexadecimal: String {
    String(binaryToInt, radix: 16)
  }
}
