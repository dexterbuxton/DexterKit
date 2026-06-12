import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {

  /// A color that resolves to `light` or `dark` based on the active color scheme.
  ///
  /// Built entirely in code — no asset catalog required. The result is a single
  /// dynamic `Color` that updates automatically when the scheme changes, so it
  /// needs no `@Environment(\.colorScheme)` at the call site.
  public init(light: Color, dark: Color) {
    #if canImport(UIKit)
    self = Color(uiColor: UIColor { traits in
      traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
    })
    #elseif canImport(AppKit)
    self = Color(nsColor: NSColor(name: nil) { appearance in
      appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
    })
    #else
    self = light
    #endif
  }
}
