import Testing
import SwiftUI
@testable import CustomControls

// MARK: Symbol Identity

@Suite("Icon Representable")
struct IconRepresentableTests {

  @Test("EmptyIcon renders nothing and has no label")
  func emptyIconIsBlank() {
    let symbol = EmptyIcon()
    #expect(symbol.name == nil)
    #expect(symbol.accessibilityLabel.isEmpty)
  }

  @Test("FilledDotIcon is a filled circle")
  func filledDotIsCircle() {
    let symbol = FilledDotIcon()
    #expect(symbol.name == "circle.fill")
    #expect(symbol.accessibilityLabel == "Selected")
  }

  @Test("IconType bridges systemImage to symbolName")
  func iconTypeBridgesSymbolName() {
    #expect(IconType.back.name == "chevron.backward")
    #expect(IconType.undo.name == "arrow.uturn.backward")
    #expect(IconType.delete.symbolName == "xmark.square")
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
    #expect(IconButtonTheme().iconWeight == .medium)
  }

  @Test("Custom values round-trip")
  func customValuesRoundTrip() {
    let theme = IconButtonTheme(iconColor: .red, backgroundColor: .blue, iconWeight: .bold)
    #expect(theme.iconColor == .red)
    #expect(theme.backgroundColor == .blue)
    #expect(theme.iconWeight == .bold)
  }
}
