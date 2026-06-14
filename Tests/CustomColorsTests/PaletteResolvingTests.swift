import Testing
import SwiftUI
@testable import CustomColors

struct PaletteResolvingTests {

  @Test func testElementByName() throws {
    let palette = Palette.material
    #expect(palette.element(for: "Neutral")?.name == "Neutral")
    #expect(palette.element(for: "neutral")?.name == "Neutral")   // case-insensitive
    #expect(palette.element(for: "Red")?.name == "Red")
  }

  @Test func testElementByHex() throws {
    let palette = Palette.material
    #expect(palette.element(for: "F44336")?.name == "Red")
    #expect(palette.element(for: "f44336")?.name == "Red")        // case-insensitive
  }

  @Test func testElementMissing() throws {
    #expect(Palette.material.element(for: "000000") == nil)       // valid hex, not in palette
    #expect(Palette.material.element(for: "bogus") == nil)
  }

  @Test func testColorResolves() throws {
    #expect(Palette.material.color(for: "Neutral") != nil)        // known name
    #expect(Palette.material.color(for: "000000") != nil)         // off-palette valid hex
    #expect(Palette.material.color(for: "bogus") == nil)          // neither
    #expect(Palette.material.color(for: "12345") == nil)          // wrong length
  }

  @Test func testHexValidating() throws {
    #expect(Hex(validating: "F44336") != nil)
    #expect(Hex(validating: "#F44336") != nil)                    // leading hash
    #expect(Hex(validating: "GGGGGG") == nil)                     // non-hex chars
    #expect(Hex(validating: "F443") == nil)                       // wrong length
  }
}
