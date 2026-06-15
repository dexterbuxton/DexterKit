import SwiftUI

/// Cross-platform adaptive system colors.
///
/// SwiftUI's `Color(.systemBackground)` / `Color(.separator)` route through
/// `UIColor`, which doesn't exist on macOS, so referencing them directly fails
/// to compile in a multiplatform package. These shims resolve to the right
/// native color on each platform while staying fully adaptive to light/dark.
public extension Color {

  /// The base system background — white in light, black in dark on iOS;
  /// the window background on macOS. Adaptive and cross-platform.
  ///
  /// Useful as a "cutout" color: a border in this color reads as the surface
  /// behind the control showing through.
  static var systemBackground: Color {
    #if canImport(UIKit)
    Color(uiColor: .systemBackground)
    #elseif canImport(AppKit)
    Color(nsColor: .windowBackgroundColor)
    #else
    Color.clear
    #endif
  }

  /// A translucent hairline separator color. Adaptive and cross-platform.
  ///
  /// Because it carries alpha, it composites against whatever sits behind it,
  /// reading consistently over arbitrary fills rather than clashing the way a
  /// solid border would.
  static var separator: Color {
    #if canImport(UIKit)
    Color(uiColor: .separator)
    #elseif canImport(AppKit)
    Color(nsColor: .separatorColor)
    #else
    Color.gray.opacity(0.3)
    #endif
  }
}
