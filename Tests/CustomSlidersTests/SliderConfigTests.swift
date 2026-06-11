import Testing
import Foundation
@testable import CustomSliders

struct SliderConfigTests {

  var config: SliderConfig
  init() throws {
    config = SliderConfig(value: 5, range: (0...10), thumbSize: 40, step: 0.5)
  }

  @Test func testInitializer() throws {
    // Test the initial configuration
    #expect(config.value == 5)
    #expect(config.percent == 0.5)

    // Create a new instance to test different values
    let config = SliderConfig(value: 50, range: 0...100, thumbSize: 40, step: 0.5)
    #expect(config.value == 50)
    #expect(config.percent == 0.5)
  }

  @Test func testValueOutOfRange() throws {
    var config = SliderConfig(value: 10, range: 0...1, thumbSize: 40, step: 0.5)
    #expect(config.value == 1)
    #expect(config.percent == 1)
    config = SliderConfig(value: -20, range: 0...1, thumbSize: 40, step: 0.5)
    #expect(config.value == 0)
    #expect(config.percent == 0)
  }

  @Test func testNegativeRange() throws {
    // Positive to Negative Range
    var config = SliderConfig(value: 0, range: -10...10, thumbSize: 40, step: 0.5)
    #expect(config.value == 0)
    #expect(config.percent == 0.5)
    config = SliderConfig(value: -5, range: -10...10, thumbSize: 40, step: 0.5)
    #expect(config.value == -5)
    #expect(config.percent == 0.25)

    // Negative to Zero Range
    config = SliderConfig(value: -1, range: -5...0, thumbSize: 40, step: 0.5)
    #expect(config.value == -1)
    #expect(config.percent == 0.8)
    config = SliderConfig(value: -4, range: -5...0, thumbSize: 40, step: 0.5)
    #expect(config.value == -4)
    #expect(config.percent == 0.2)

    // Extra Negative Range
    config = SliderConfig(value: -19, range: -20...(-15), thumbSize: 40, step: 0.5)
    #expect(config.value == -19)
    #expect(config.percent == 0.2)
    config = SliderConfig(value: -16, range: -20...(-15), thumbSize: 40, step: 0.5)
    #expect(config.value == -16)
    #expect(config.percent == 0.8)
  }

  @Test func testPositiveRange() throws {
    // Extra Positive Range
    var config = SliderConfig(value: 82, range: 50...100, thumbSize: 40, step: 0.5)
    #expect(config.value == 82)
    #expect(config.percent == 0.64)
    config = SliderConfig(value: 62, range: 50...100, thumbSize: 40, step: 0.5)
    #expect(config.value == 62)
    #expect(config.percent == 0.24)

    // Positive Range
    config = SliderConfig(value: 11, range: 10...20, thumbSize: 40, step: 0.5)
    #expect(config.value == 11)
    #expect(config.percent == 0.1)
    config = SliderConfig(value: 12, range: 10...20, thumbSize: 40, step: 0.5)
    #expect(config.value == 12)
    #expect(config.percent == 0.2)
    config = SliderConfig(value: 18, range: 10...20, thumbSize: 40, step: 0.5)
    #expect(config.value == 18)
    #expect(config.percent == 0.8)
  }

  @Test func testNoRange() throws {
    var config = SliderConfig(value: 0, range: 0...0, thumbSize: 40, step: 0.5)
    #expect(config.value == 0)
    #expect(config.percent == 0)
    config = SliderConfig(value: 10, range: 0...0, thumbSize: 40, step: 0.5)
    #expect(config.value == 0)
    #expect(config.percent == 0)
    config = SliderConfig(value: -10, range: 0...0, thumbSize: 40, step: 0.5)
    #expect(config.value == 0)
    #expect(config.percent == 0)
    config = SliderConfig(value: -10, range: 1...1, thumbSize: 40, step: 0.5)
    #expect(config.value == 1)
    #expect(config.percent == 0)
  }

  @Test func testPosition() throws {
    var position = config.position(given: 200)
    #expect(position.y == 20)
    #expect(position.x == 100)
    config.value = 0
    position = config.position(given: 200)
    #expect(position.x == 20)
    config.value = 10
    position = config.position(given: 200)
    #expect(position.x == 180)
    config.value = 2
    position = config.position(given: 200)
    #expect(position.x == 52)
    config.value = 7
    position = config.position(given: 200)
    #expect(position.x == 132)
  }

  @Test func testMove() throws {
    let position = config.position(given: 200)
    #expect(position.y == 20)
    #expect(position.x == 100)
    config.move(from: 100, to: 20, given: 200)
    config.stop()
    #expect(config.value == 0)
    config.move(from: 20, to: 180, given: 200)
    config.stop()
    #expect(config.value == 10)
    config.move(from: 180, to: 50, given: 200)
    config.stop()
    #expect(config.value == 1.875)
    config.move(from: 50, to: 160, given: 200)
    config.stop()
    #expect(config.value == 8.75)
    // Test zero width (No change)
    config.move(from: 50, to: 160, given: 0)
    config.stop()
    #expect(config.value == 8.75)
  }

  @Test func testStep() throws {
    #expect(config.value == 5)
    config.step(at: 50, given: 200)
    #expect(config.value == 4.5)
    config.step(at: 50, given: 200)
    #expect(config.value == 4.0)
    config.step(at: 150, given: 200)
    #expect(config.value == 4.5)
    config.step(at: 150, given: 200)
    #expect(config.value == 5.0)

    let config = SliderConfig(value: 5, range: 0...10, thumbSize: 40, step: 0.2)
    #expect(config.value == 5)
    config.step(at: 50, given: 200)
    #expect(config.value == 4.8)
    config.step(at: 50, given: 200)
    #expect(config.value == 4.6)
    config.step(at: 20, given: 200)
    config.step(at: 30, given: 200)
    config.step(at: 25, given: 200)
    #expect(config.value == 4.0)
    config.step(at: 150, given: 200)
    #expect(config.value == 4.2)
    config.step(at: 180, given: 200)
    #expect(config.value == 4.4)
    config.step(at: 50, given: 200)
    #expect(config.value == 4.2)
    config.step(at: 180, given: 200)
    config.step(at: 185, given: 200)
    config.step(at: 150, given: 200)
    config.step(at: 165, given: 200)
    #expect(config.value == 5.0)
  }
}
