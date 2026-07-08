import Testing
import SwiftUI
@testable import CustomControls

// MARK: Symbol Identity

@Suite("Icon Representable")
struct IconRepresentableTests {

  @Test("EmptyIcon renders nothing and has no label")
  func emptyIconIsBlank() {
    let symbol = EmptyIcon()
    #expect(symbol.symbolName == nil)
    #expect(symbol.accessibilityLabel.isEmpty)
  }

  @Test("FilledDotIcon is a filled circle")
  func filledDotIsCircle() {
    let symbol = FilledDotIcon()
    #expect(symbol.symbolName == "circle.fill")
    #expect(symbol.accessibilityLabel == "Selected")
  }

  @Test("IconType bridges systemImage to symbolName")
  func iconTypeBridgesSymbolName() {
    #expect(IconType.back.symbolName == "chevron.backward")
    #expect(IconType.undo.symbolName == "arrow.uturn.backward")
    #expect(IconType.trash.symbolName == "trash")
  }
}

// MARK: Icon Value

@Suite("Icon")
struct IconValueTests {

  @Test("Icon from an empty symbol is empty")
  func emptySymbolProducesEmptyIcon() {
    let icon = Icon(EmptyIcon(), color: .primary)
    #expect(icon.isEmpty)
    #expect(icon.symbolName == nil)
  }

  @Test("Icon from an IconType carries symbol and label")
  func iconTypeProducesResolvedFields() {
    let icon = Icon(IconType.undo, color: .red)
    #expect(!icon.isEmpty)
    #expect(icon.symbolName == "arrow.uturn.backward")
    #expect(icon.accessibilityLabel == "Undo")
    #expect(icon.color == .red)
  }
}

// MARK: Theme

@Suite("Icon Button Theme")
struct IconButtonThemeTests {

  @Test("Default weight matches the configuration constant")
  func defaultWeightIsMedium() {
    #expect(IconButtonTheme().weight == .medium)
  }

  @Test("Custom values round-trip")
  func customValuesRoundTrip() {
    let colors = IconButtonColors(foreground: .red, background: .blue)
    let theme = IconButtonTheme(colors: colors, weight: .bold)
    #expect(theme.colors.foreground == .red)
    #expect(theme.colors.background == .blue)
    #expect(theme.weight == .bold)
  }
}
