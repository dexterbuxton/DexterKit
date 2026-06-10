import Foundation

public extension ClosedRange {
  /// Clamps a given value to ensure it falls within the bounds of the range.
  func clamp(_ value: Bound) -> Bound {
    if lowerBound > value {
      return lowerBound
    }
    else if upperBound < value {
      return upperBound
    }
    return value
  }
}
