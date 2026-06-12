import SwiftUI

/// The visual shape of a button's background.
public enum CustomButtonStyle: Equatable, Sendable {
  /// A circular background (rendered as a capsule on non-square frames).
  case circle
  /// A rounded-rectangle background.
  case rectangle
}
