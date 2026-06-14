import Foundation

public extension Hex {

  /// Creates a hex from a 6-digit code, or `nil` if the string isn't a valid hex
  /// color. Accepts an optional leading `#`.
  ///
  /// Use this — rather than `init(_:)`, which always falls back — when a string
  /// might *not* be a color, e.g. when resolving a stored value that could be a
  /// color name instead.
  init?(validating code: String) {
    let trimmed = code.hasPrefix("#") ? String(code.dropFirst()) : code
    guard trimmed.count == 6, trimmed.allSatisfy(\.isHexDigit) else {
      return nil
    }
    self.init(trimmed)
  }
}
