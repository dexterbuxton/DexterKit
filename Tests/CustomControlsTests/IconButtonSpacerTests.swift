import Testing
@testable import CustomControls

struct IconButtonSpacerTests {

  @Test func testSpacerIsEmpty() throws {
    #expect(IconButtonItem.spacer.isEmpty)
    #expect(IconButtonItem().isEmpty)
  }

  @Test func testRegularItemIsNotEmpty() throws {
    #expect(IconButtonItem(.back, action: {}).isEmpty == false)
  }

  @Test func testSpacerBuildsInGroup() throws {
    // A spacer flows through the result builder like any other slot.
    @IconButtonItemBuilder func items() -> [IconButtonItem] {
      IconButtonItem(.back, action: {})
      IconButtonItem.spacer
      IconButtonItem(.forward, action: {})
    }
    let built = items()
    #expect(built.count == 3)
    #expect(built[1].isEmpty)
  }
}
