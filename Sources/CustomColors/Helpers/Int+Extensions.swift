import Foundation

/// Radix string helpers used by the color models.
public extension Int {

  /// The binary string representation of the integer.
  /// - Example: `255.binaryString` returns `"11111111"`.
  var binaryString: String {
    String(self, radix: 2)
  }

  /// The hexadecimal string representation of the integer.
  /// - Example: `255.hexadecimalString` returns `"ff"`.
  var hexadecimalString: String {
    String(self, radix: 16)
  }
}
