import Testing
import SwiftUI
@testable import CustomControls

struct CustomButtonConfigurationTests {

  @Test func testCornerRadiusForStyle() {
    #expect(CustomButtonConfiguration.cornerRadius(for: .circle) == CustomButtonConfiguration.circleCornerRadius)
    #expect(CustomButtonConfiguration.cornerRadius(for: .circle) == .infinity)
    #expect(CustomButtonConfiguration.cornerRadius(for: .square) == CustomButtonConfiguration.squareCornerRadius)
    #expect(CustomButtonConfiguration.cornerRadius(for: .square) == 8)
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
    // Generic (unsized) content buttons still use a proportional scale.
    #expect(CustomButtonConfiguration.pressedBackgroundScale > CustomButtonConfiguration.normalScale)
    #expect(CustomButtonConfiguration.pressedIconScale > CustomButtonConfiguration.normalIconScale)
    #expect(CustomButtonConfiguration.minimumAnimationCycle > 0)
  }

  @Test func testAnimationDurationsAreSped() {
    // All three press-related durations were doubled in speed (halved) together.
    #expect(CustomButtonConfiguration.backgroundAnimationDuration == 0.1)
    #expect(CustomButtonConfiguration.iconAnimationDuration == 0.1)
    #expect(CustomButtonConfiguration.iconScaleAnimationDuration == 0.1)
  }

  @Test func testPressExpansionIsHalfOfGroupSpacing() {
    // Sized icon buttons (standalone and grouped) use a fixed-point expansion
    // instead of a proportional scale, deliberately set to half of
    // groupSpacing so a pressed group button doesn't overlap its neighbor.
    #expect(CustomButtonConfiguration.defaultPressExpansion == CustomButtonConfiguration.groupSpacing / 2)
    #expect(CustomButtonConfiguration.defaultPressExpansion == 4)
  }

  @Test func testMaxGroupInnerPaddingIsPositive() {
    // Caps how much spacing above the 2pt threshold gets reallocated to a
    // group's outer edges — see `IconButtonGroup`'s spacing reallocation.
    #expect(CustomButtonConfiguration.maxGroupInnerPadding > 0)
  }

  @Test func testTextButtonDefaults() {
    #expect(CustomButtonConfiguration.textButtonWidth > 0)
    #expect(CustomButtonConfiguration.textButtonContentSpacing > 0)
    #expect(CustomButtonConfiguration.textButtonContentPadding > 0)
  }
}
