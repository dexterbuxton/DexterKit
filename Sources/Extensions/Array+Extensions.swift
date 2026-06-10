import Foundation

public extension Array {

  /// Splits the array into chunks (subarrays) of at most `size` elements.
  ///
  /// Useful for grouping elements into fixed-size batches.
  ///
  /// ```swift
  /// [1, 2, 3, 4, 5].chunked(into: 2) // [[1, 2], [3, 4], [5]]
  /// [1, 2, 3, 4, 5].chunked(into: 0) // []
  /// ```
  ///
  /// - Parameter size: The maximum size of each chunk. Must be greater than `0`.
  /// - Returns: A 2D array where each subarray contains up to `size` elements.
  func chunked(into size: Int) -> [[Element]] {
    guard size > 0 else { return [] }
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }

  /// Converts each element to a string and joins them with a separator.
  ///
  /// Uses `String(describing:)` for each element, so it works for any element type.
  ///
  /// ```swift
  /// [1, 2, 3].toJoinedString()                  // "1, 2, 3"
  /// [1, 2, 3].toJoinedString(separator: " | ")  // "1 | 2 | 3"
  /// ```
  ///
  /// - Parameter separator: The string to place between elements. Defaults to `", "`.
  /// - Returns: A single string of the joined element descriptions.
  func toJoinedString(separator: String = ", ") -> String {
    map { String(describing: $0) }.joined(separator: separator)
  }
}

public extension Array where Element: Hashable {

  /// Returns the array with duplicate elements removed, preserving original order.
  ///
  /// The first occurrence of each element is kept; later duplicates are discarded.
  ///
  /// ```swift
  /// [1, 2, 2, 3, 1].removingDuplicates() // [1, 2, 3]
  /// ```
  ///
  /// - Returns: A new array containing only the unique elements, in their original order.
  func removingDuplicates() -> [Element] {
    var seen = Set<Element>()
    return filter { seen.insert($0).inserted }
  }
}
