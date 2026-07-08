import Testing
import SwiftUI
@testable import CustomControls

struct ButtonEnvironmentValuesTests {

  @Test func testSizeAndExpansionDefaults() {
    let environment = EnvironmentValues()
    #expect(environment.buttonSize == CustomButtonConfiguration.buttonSize)
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
    environment.buttonSize = 60
    environment.buttonPressExpansion = 10
    environment.iconColorOverride = .red
    environment.textButtonIconTrailing = true
    environment.textButtonContentAlignment = .leading

    #expect(environment.buttonSize == 60)
    #expect(environment.buttonPressExpansion == 10)
    #expect(environment.iconColorOverride == .red)
    #expect(environment.textButtonIconTrailing)
    #expect(environment.textButtonContentAlignment == .leading)
  }
}
