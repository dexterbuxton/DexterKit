import SwiftUI

extension Font.Weight {

  /// Weights in ascending visual order, for relative stepping.
  private static let ordered: [Font.Weight] = [
    .ultraLight, .thin, .light, .regular, .medium, .semibold, .bold, .heavy, .black
  ]

  /// Returns a weight `steps` heavier, clamped to `.black`.
  /// Returns `self` unchanged if `steps <= 0` or the weight isn't in the table.
  func bolder(by steps: Int = 1) -> Font.Weight {
    guard steps > 0, let index = Self.ordered.firstIndex(of: self) else { return self }
    return Self.ordered[min(index + steps, Self.ordered.count - 1)]
  }
}
