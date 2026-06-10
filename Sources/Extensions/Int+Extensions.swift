import Foundation

public extension Int {

  /// The greatest common divisor of `self` and `other`.
  ///
  /// - Parameter other: The other integer to compare against.
  /// - Returns: The largest integer that divides both values. Returns `0` only when both values are `0`.
  /// - Example: `12.gcd(with: 8)` returns `4`.
  func gcd(with other: Int) -> Int {
    var first = abs(self)
    var second = abs(other)
    while second != 0 {
      (first, second) = (second, first % second)
    }
    return first
  }

  /// The least common multiple of `self` and `other`.
  ///
  /// - Parameter other: The other integer to combine with.
  /// - Returns: The smallest positive integer divisible by both values, or `0` if either value is `0`.
  /// - Example: `4.lcm(with: 6)` returns `12`.
  func lcm(with other: Int) -> Int {
    guard self != 0 && other != 0 else { return 0 }
    return abs(self / self.gcd(with: other) * other)
  }
}
