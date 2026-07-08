import Testing
import SwiftUI
@testable import CustomControls

struct ButtonEnvironmentValuesTests {

  @Test func testSizeAndExpansionDefaults() {
    let environment = EnvironmentValues()
    let expectedSize = CGSize(width: CustomButtonConfiguration.buttonSize, height: CustomButtonConfiguration.buttonSize)
    #expect(environment.buttonSize == expectedSize)
    #expect(environment.buttonPressExpansion == CustomButtonConfiguration.defaultPressExpansion)
    #expect(environment.buttonWidth == CustomButtonConfiguration.textButtonWidth)
  }

  @Test func testColorOverridesDefaultToNil() {
    let environment = EnvironmentValues()
    #expect(environment.iconColorOverride == nil)
    #expect(environment.iconBackgroundOverride == nil)
  }

  @Test func testTextButtonDefaults() {
    let environment = EnvironmentValues()
    #expect(environment.textButtonIconTrailing == false)
    #expect(environment.textButtonContentAlignment == .center)
    #expect(environment.textButtonContentSpacing == CustomButtonConfiguration.textButtonContentSpacing)
    #expect(environment.textButtonContentPadding == CustomButtonConfiguration.textButtonContentPadding)
  }

  @Test func testValuesRoundTripThroughSetter() {
    var environment = EnvironmentValues()
    environment.buttonSize = CGSize(width: 60, height: 60)
    environment.buttonPressExpansion = 10
    environment.iconColorOverride = .red
    environment.textButtonIconTrailing = true
    environment.textButtonContentAlignment = .leading

    #expect(environment.buttonSize == CGSize(width: 60, height: 60))
    #expect(environment.buttonPressExpansion == 10)
    #expect(environment.iconColorOverride == .red)
    #expect(environment.textButtonIconTrailing)
    #expect(environment.textButtonContentAlignment == .leading)
  }

  @Test func testButtonSizeSupportsIndependentWidthAndHeight() {
    var environment = EnvironmentValues()
    environment.buttonSize = CGSize(width: 80, height: 44)

    #expect(environment.buttonSize.width == 80)
    #expect(environment.buttonSize.height == 44)
  }
}
