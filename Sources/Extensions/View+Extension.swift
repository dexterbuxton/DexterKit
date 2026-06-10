import SwiftUI

public extension View {
  /// Generic Modifier for SwiftUI Views
  func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
    var copy = self
    copy[keyPath: keyPath] = value
    return copy
  }
}
