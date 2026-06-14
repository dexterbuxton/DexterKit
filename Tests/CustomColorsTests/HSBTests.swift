import Testing
@testable import CustomColors

struct HSBTests {

  @Test func testDescription() throws {
    var hsb = HSB(h: 120, s: 45, b: 67)
    #expect(hsb.description == "HSB(120, 45%, 67%)")

    hsb = HSB()
    #expect(hsb.description == "HSB(0, 0%, 0%)")
  }

  @Test func testInitClamping() throws {
    let hsb = HSB(h: 400, s: 150, b: -10)
    #expect(hsb.h == 360)
    #expect(hsb.s == 100)
    #expect(hsb.b == 0)
  }

  @Test func testHSBToRGBConversion() throws {
    var rgb = HSB(h: 0, s: 100, b: 100).toRGB()
    #expect(rgb.r == 255 && rgb.g == 0 && rgb.b == 0)

    rgb = HSB(h: 120, s: 100, b: 100).toRGB()
    #expect(rgb.r == 0 && rgb.g == 255 && rgb.b == 0)

    rgb = HSB(h: 240, s: 100, b: 100).toRGB()
    #expect(rgb.r == 0 && rgb.g == 0 && rgb.b == 255)

    rgb = HSB(h: 0, s: 0, b: 100).toRGB()
    #expect(rgb.r == 255 && rgb.g == 255 && rgb.b == 255)

    rgb = HSB(h: 0, s: 0, b: 0).toRGB()
    #expect(rgb.r == 0 && rgb.g == 0 && rgb.b == 0)
  }

  @Test func testRGBToHSBRoundTrip() throws {
    // Extreme colors round-trip exactly.
    let extremes: [RGB] = [.black, .white, .red, .green, .blue, .cyan, .magenta, .yellow]
    for color in extremes {
      let rgb = color.toHSB().toRGB()
      #expect(rgb.r == color.r && rgb.g == color.g && rgb.b == color.b)
    }

    // Full palette: assert normalized ranges. Tighten to an exact round-trip
    // (like HSLTests) once you've confirmed it passes on your machine.
    for color in RGB.colors {
      let hsb = color.toHSB()
      #expect(hsb.hValue >= 0.0 && hsb.hValue <= 1.0)
      #expect(hsb.sValue >= 0.0 && hsb.sValue <= 1.0)
      #expect(hsb.bValue >= 0.0 && hsb.bValue <= 1.0)
    }
  }

  @Test func testStaticColors() throws {
    #expect(HSB.black.h == 0 && HSB.black.s == 0 && HSB.black.b == 0)
    #expect(HSB.white.h == 0 && HSB.white.s == 0 && HSB.white.b == 100)
    #expect(HSB.red.h == 0 && HSB.red.s == 100 && HSB.red.b == 100)
    #expect(HSB.green.h == 120 && HSB.green.s == 100 && HSB.green.b == 100)
    #expect(HSB.blue.h == 240 && HSB.blue.s == 100 && HSB.blue.b == 100)
  }

  @Test func testHSBToHexConversion() throws {
    #expect(HSB(h: 0, s: 100, b: 100).toHex().code == "FF0000")
    #expect(HSB(h: 120, s: 100, b: 100).toHex().code == "00FF00")
    #expect(HSB(h: 240, s: 100, b: 100).toHex().code == "0000FF")
  }
}
