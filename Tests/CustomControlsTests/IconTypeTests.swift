import Testing
@testable import CustomControls

struct IconTypeTests {

  @Test func testEveryCaseHasSystemImage() {
    for icon in IconType.allCases {
      #expect(!icon.systemImage.isEmpty)
    }
  }

  @Test func testEveryCaseHasAccessibilityLabel() {
    for icon in IconType.allCases {
      #expect(!icon.accessibilityLabel.isEmpty)
    }
  }

  @Test func testPreviewGroupsCoverAllCasesWithoutDuplicates() {
    let grouped = IconType.previewGroups.flatMap { $0.icons }
    #expect(Set(grouped) == Set(IconType.allCases))
    #expect(grouped.count == IconType.allCases.count)
  }

  @Test func testKnownMappings() {
    #expect(IconType.undo.systemImage == "arrow.uturn.backward")
    #expect(IconType.undo.accessibilityLabel == "Undo")
    #expect(IconType.trash.systemImage == "trash")
    #expect(IconType.done.accessibilityLabel == "Done")
  }
}
