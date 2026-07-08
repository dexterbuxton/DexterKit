import Testing
@testable import CustomControls

struct IconButtonGroupStyleTests {

  @Test func testCircleSpacingUsesGroupSpacingConstant() {
    #expect(IconButtonGroup.Style.circle.spacing == CustomButtonConfiguration.groupSpacing)
  }

  @Test func testSquareSpacingUsesItsOwnValue() {
    #expect(IconButtonGroup.Style.square(spacing: 12).spacing == 12)
    #expect(IconButtonGroup.Style.square(spacing: 0).spacing == 0)
  }

  @Test func testStylesWithEqualSpacingAreEqual() {
    #expect(IconButtonGroup.Style.square(spacing: 8) == .square(spacing: 8))
    #expect(IconButtonGroup.Style.square(spacing: 8) != .square(spacing: 10))
    #expect(IconButtonGroup.Style.circle == .circle)
  }
}
