import Testing
import SwiftUI
@testable import CustomControls

struct CustomButtonConfigurationTests {

  @Test func testCornerRadiusForStyle() {
    #expect(CustomButtonConfiguration.cornerRadius(for: .circle) == CustomButtonConfiguration.circleCornerRadius)
    #expect(CustomButtonConfiguration.cornerRadius(for: .circle) == .infinity)
    #expect(CustomButtonConfiguration.cornerRadius(for: .rectangle) == CustomButtonConfiguration.roundedRectangleCornerRadius)
    #expect(CustomButtonConfiguration.cornerRadius(for: .rectangle) == 8)
  }

  @Test func testIconSizeScalesWithButtonSize() {
    #expect(CustomButtonConfiguration.iconSize(for: 0) == 0)
    #expect(CustomButtonConfiguration.iconSize(for: 44) == 44 * CustomButtonConfiguration.iconSizeRatio)
    #expect(CustomButtonConfiguration.iconSize(for: 100) == 100 * CustomButtonConfiguration.iconSizeRatio)
  }

  @Test func testRatiosAreFractions() {
    #expect(CustomButtonConfiguration.iconSizeRatio > 0)
    #expect(CustomButtonConfiguration.iconSizeRatio <= 1)
    #expect(CustomButtonConfiguration.indicatorDotRatio > 0)
    #expect(CustomButtonConfiguration.indicatorDotRatio <= 1)
  }

  @Test func testOpacityBounds() {
    #expect(CustomButtonConfiguration.disabledOpacity >= 0)
    #expect(CustomButtonConfiguration.disabledOpacity <= 1)
    #expect(CustomButtonConfiguration.enabledOpacity == 1)
    #expect(CustomButtonConfiguration.pressedIconOpacity > 0)
    #expect(CustomButtonConfiguration.pressedIconOpacity <= 1)
  }

  @Test func testAnimationScalesArePositive() {
    #expect(CustomButtonConfiguration.pressedBackgroundScale > CustomButtonConfiguration.normalScale)
    #expect(CustomButtonConfiguration.pressedIconScale > CustomButtonConfiguration.normalIconScale)
    #expect(CustomButtonConfiguration.minimumAnimationCycle > 0)
  }
}
