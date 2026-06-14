import Testing
@testable import CustomColors

struct PaletteColorTests {

  @Test func testHexBackingIsValid() throws {
    // Every case resolves to a real 6-character hex (never the fallback by accident).
    for paletteColor in PaletteColor.allCases {
      #expect(paletteColor.hex.code.count == 6)
    }
  }

  @Test func testRGBMatchesHex() throws {
    // The derived RGB must agree with the backing Hex on every channel.
    for paletteColor in PaletteColor.allCases {
      let hex = paletteColor.hex
      let rgb = paletteColor.rgb
      #expect(rgb.r == hex.r)
      #expect(rgb.g == hex.g)
      #expect(rgb.b == hex.b)
    }
  }

  @Test func testKnownValues() throws {
    // Smoke checks — these track the Material-500 defaults in `hex`.
    #expect(PaletteColor.red.hex.code == "F44336")
    #expect(PaletteColor.red.rgb.r == 244)
    #expect(PaletteColor.red.rgb.g == 67)
    #expect(PaletteColor.red.rgb.b == 54)
    #expect(PaletteColor.blue.hex.code == "2196F3")
  }

  @Test func testRawValueRoundTrip() throws {
    // Persistence contract: rawValue out, same case back in.
    for paletteColor in PaletteColor.allCases {
      #expect(PaletteColor(rawValue: paletteColor.rawValue) == paletteColor)
    }
    #expect(PaletteColor(rawValue: "red") == .red)
    #expect(PaletteColor(rawValue: "deepPurple") == .deepPurple)
    #expect(PaletteColor(rawValue: "notacolor") == nil)
  }

  @Test func testDisplayName() throws {
    #expect(PaletteColor.deepPurple.displayName == "Deep Purple")
    #expect(PaletteColor.lightGreen.displayName == "Light Green")
    #expect(PaletteColor.red.displayName == "Red")
  }

  @Test func testGridOrder() throws {
    // 8×2 grid: 16 unique entries, all valid cases.
    #expect(PaletteColor.gridOrder.count == 16)
    #expect(Set(PaletteColor.gridOrder).count == 16)
  }
}
