import Testing
import SwiftUI
@testable import CustomControls

struct IconButtonItemTests {

  @Test func testTypeSlotInheritsDefaultColor() {
    let item = IconButtonItem(.undo, action: {})
    let icon = item.resolvedIcon(defaultColor: .red)
    #expect(icon.type == .undo)
    #expect(icon.color == .red)
    #expect(icon.accentColor == nil)
  }

  @Test func testTypeSlotPassesAccentColor() {
    let item = IconButtonItem(.gridOn, accentColor: .blue, action: {})
    let icon = item.resolvedIcon(defaultColor: .red)
    #expect(icon.accentColor == .blue)
  }

  @Test func testIconSlotKeepsItsOwnColor() {
    let item = IconButtonItem(Icon(.delete, color: .green), action: {})
    let icon = item.resolvedIcon(defaultColor: .red)
    #expect(icon.type == .delete)
    #expect(icon.color == .green)
  }

  @Test func testDisabledFlag() {
    #expect(IconButtonItem(.undo, isDisabled: true, action: {}).isDisabled)
    #expect(IconButtonItem(.undo, action: {}).isDisabled == false)
  }

  @Test func testItemBuilderFlattens() {
    @IconButtonItemBuilder
    func make(includeExtra: Bool) -> [IconButtonItem] {
      IconButtonItem(.undo, action: {})
      IconButtonItem(.redo, action: {})
      if includeExtra {
        IconButtonItem(.delete, action: {})
      }
    }
    #expect(make(includeExtra: false).count == 2)
    #expect(make(includeExtra: true).count == 3)
  }
}
