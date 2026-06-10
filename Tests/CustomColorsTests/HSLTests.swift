import Testing
@testable import CustomColors

struct HSLTests {

  @Test func testInitializer() throws {
    var hsl = HSL()
    #expect(hsl.h == 0 && hsl.s == 0 && hsl.l == 0)
    #expect(hsl.hValue == 0.0 && hsl.sValue == 0.0 && hsl.lValue == 0.0)

    hsl = HSL(h: 180, s: 50, l: 25)
    #expect(hsl.h == 180 && hsl.s == 50 && hsl.l == 25)
    #expect(hsl.hValue == 0.5 && hsl.sValue == 0.5 && hsl.lValue == 0.25)

    hsl = HSL(h: 0.5, s: 0.5, l: 0.25)
    #expect(hsl.h == 180 && hsl.s == 50 && hsl.l == 25)
    #expect(hsl.hValue == 0.5 && hsl.sValue == 0.5 && hsl.lValue == 0.25)
  }

  @Test func testSettingValues() throws {
    var hsl = HSL()

    hsl.h = 270
    #expect(hsl.h == 270)
    #expect(hsl.hValue == 0.75)

    hsl.s = 75
    #expect(hsl.s == 75)
    #expect(hsl.sValue == 0.75)

    hsl.l = 40
    #expect(hsl.l == 40)
    #expect(hsl.lValue == 0.4)

    hsl.hValue = 0.1
    #expect(hsl.h == 36)
    #expect(hsl.hValue == 0.1)

    hsl.sValue = 0.2
    #expect(hsl.s == 20)
    #expect(hsl.sValue == 0.2)

    hsl.lValue = 0.3
    #expect(hsl.l == 30)
    #expect(hsl.lValue == 0.3)
  }

  @Test func testInvalidValues() throws {
    var hsl = HSL(h: 400, s: 150, l: 200)
    #expect(hsl.h == 360 && hsl.s == 100 && hsl.l == 100)
    #expect(hsl.hValue == 1.0 && hsl.sValue == 1.0 && hsl.lValue == 1.0)

    hsl.h = -10
    #expect(hsl.h == 0)
    #expect(hsl.hValue == 0.0)

    hsl.s = -50
    #expect(hsl.s == 0)
    #expect(hsl.sValue == 0.0)

    hsl.l = -100
    #expect(hsl.l == 0)
    #expect(hsl.lValue == 0.0)

    hsl.hValue = 1.5
    #expect(hsl.h == 360)
    #expect(hsl.hValue == 1.0)

    hsl.sValue = -0.5
    #expect(hsl.s == 0)
    #expect(hsl.sValue == 0.0)

    hsl.lValue = 2.0
    #expect(hsl.l == 100)
    #expect(hsl.lValue == 1.0)
  }

  @Test func testDescription() throws {
    var hsl = HSL(h: 123, s: 45, l: 67)
    #expect(hsl.description == "HSL(123, 45%, 67%)")

    hsl = HSL()
    #expect(hsl.description == "HSL(0, 0%, 0%)")
  }

  // MARK: Extension Tests

  @Test func testHSLToRGBConversion() throws {
    let hsl = HSL(h: 180, s: 50, l: 50)
    let rgb = hsl.toRGB()
    #expect(rgb.r == 64 && rgb.g == 191 && rgb.b == 191)

    let colors: [HSL] = [.black, .white, .red, .green, .blue, .cyan, .magenta, .yellow, .gray, .lightGray, .darkGray, .orange, .purple, .pink, .brown]
    for color in colors {
      let rgb = color.toRGB()
      let hslFromRGB = rgb.toHSL()
      #expect(hslFromRGB.h == color.h && hslFromRGB.s == color.s && hslFromRGB.l == color.l)
    }
  }

  @Test func testRGBToHSLConversion() throws {
    let rgb = RGB(r: 64, g: 191, b: 191)
    let hsl = rgb.toHSL()
    #expect(hsl.h == 180 && hsl.s == 50 && hsl.l == 50)

    let colors: [RGB] = [.black, .white, .red, .green, .blue, .cyan, .magenta, .yellow]
    for color in colors {
      let hsl = color.toHSL()
      let rgb = hsl.toRGB()
      #expect(hsl.hValue >= 0.0 && hsl.hValue <= 1.0)
      #expect(hsl.sValue >= 0.0 && hsl.sValue <= 1.0)
      #expect(hsl.lValue >= 0.0 && hsl.lValue <= 1.0)
      #expect(rgb.r == color.r && rgb.g == color.g && rgb.b == color.b)
    }
  }

  @Test func testHSLToHexConversion() throws {
    let hsl = HSL(h: 180, s: 50, l: 50)
    let hex = hsl.toHex()
    #expect(hex.code == "40BFBF")
  }

  @Test func testHexToHSLConversion() throws {
    let hex = Hex("40BFBF")
    let hsl = hex.toHSL()
    #expect(hsl.h == 180 && hsl.s == 50 && hsl.l == 50)

    let colors: [Hex] = [.black, .white, .red, .green, .blue, .cyan, .magenta, .yellow]
    for color in colors {
      // Convert Hex to RGB
      let rgb = RGB(hex: color)
      let hexFromRGB = Hex(rgb: rgb)
      #expect(hexFromRGB.code == color.code)

      // Convert Hex to HSL
      let hsl = color.toHSL()
      let hexFromHSL = hsl.toHex()
      #expect(hexFromHSL.code == color.code)

      // Convert HSL back to RGB
      let rgbFromHSL = hsl.toRGB()
      #expect(rgbFromHSL.r == rgb.r && rgbFromHSL.g == rgb.g && rgbFromHSL.b == rgb.b)
    }
  }

  @Test func testBoundaryValues() throws {
    var hsl = HSL(h: 360, s: 100, l: 100)
    #expect(hsl.h == 360 && hsl.s == 100 && hsl.l == 100)
    #expect(hsl.hValue == 1.0 && hsl.sValue == 1.0 && hsl.lValue == 1.0)

    hsl = HSL(h: 0, s: 0, l: 0)
    #expect(hsl.h == 0 && hsl.s == 0 && hsl.l == 0)
    #expect(hsl.hValue == 0.0 && hsl.sValue == 0.0 && hsl.lValue == 0.0)
  }

  @Test func testAdditionalInitializers() throws {
    // Test initializer with RGB values
    let rgb = RGB(r: 64, g: 191, b: 191)
    var hslFromRGB = HSL(rgb: rgb)
    #expect(hslFromRGB.h == 180 && hslFromRGB.s == 50 && hslFromRGB.l == 50)

    hslFromRGB = HSL(r: 64, g: 191, b: 191)
    #expect(hslFromRGB.h == 180 && hslFromRGB.s == 50 && hslFromRGB.l == 50)

    let hslFromDouble = HSL(r: 0.25, g: 0.75, b: 0.75)
    #expect(hslFromDouble.hValue == 180.0 / 360.0)
    #expect(hslFromDouble.sValue == 0.5)
    #expect(hslFromDouble.lValue == 0.5)

    // Test initializer with Hex values
    let hex = Hex("40BFBF")
    var hslFromHex = HSL(hex: hex)
    #expect(hslFromHex.h == 180 && hslFromHex.s == 50 && hslFromHex.l == 50)

    hslFromHex = HSL(hexCode: "40BFBF")
    #expect(hslFromHex.h == 180 && hslFromHex.s == 50 && hslFromHex.l == 50)
  }
}
