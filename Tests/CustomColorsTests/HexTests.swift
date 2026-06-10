import Testing
@testable import CustomColors

struct HexTests {

  @Test func testInitializer() throws {
    let validHex = Hex("1A2B3C")
    #expect(validHex.code == "1A2B3C")

    let hexWithHash = Hex("#ABCDEF")
    #expect(hexWithHash.code == "ABCDEF")

    let lowerCaseHex = Hex("abcdef")
    #expect(lowerCaseHex.code == "ABCDEF")

    let invalidHex = Hex("ZZZZZZ")
    #expect(invalidHex.code == "000000")

    let shortHex = Hex("123")
    #expect(shortHex.code == "000000")

    let longHex = Hex("123456ABCDEF")
    #expect(longHex.code == "000000")

    let emptyHex = Hex("")
    #expect(emptyHex.code == "000000")
  }

  @Test func testSettingValues() throws {
    var hex = Hex()
    hex.code = "ABCDEF"
    #expect(hex.code == "ABCDEF")
    hex.code = "123456"
    #expect(hex.code == "123456")
    hex.code = "123ABC"
    #expect(hex.code == "123ABC")

    // Invalid Hex
    hex.code = "ZZZZZZ"
    #expect(hex.code == "000000")

    // Short Hex
    hex.code = "123"
    #expect(hex.code == "000000")
    hex.code = "abc"
    #expect(hex.code == "000000")

    // Long Hex
    hex.code = "123456ABCDEF"
    #expect(hex.code == "000000")

    // Empty Hex
    hex.code = ""
    #expect(hex.code == "000000")
  }

  @Test func testRGBConversion() throws {
    let hex = Hex("1A2B3C")
    #expect(hex.r == 26)
    #expect(hex.g == 43)
    #expect(hex.b == 60)

    let rgb = RGB(r: 26, g: 43, b: 60)
    let convertedHex = Hex(rgb: rgb)
    #expect(convertedHex.code == "1A2B3C")
  }

  @Test func testIndividualRGBInitializers() throws {
    let hex = Hex(r: 255, g: 0, b: 128)
    #expect(hex.code == "FF0080")
    #expect(hex.r == 255)
    #expect(hex.g == 0)
    #expect(hex.b == 128)
  }

  @Test func testRandomHex() throws {
    for _ in 0..<100 {
      let randomHex = Hex.random
      #expect(randomHex.code.count == 6)
      #expect(randomHex.code.allSatisfy { Hex.validCharacters.contains($0) })
    }
  }

  @Test func testRGBToHexConversion() throws {
    for value in stride(from: 0.0, through: 1.0, by: 0.001) {
      let rgb = RGB(value: value)
      let hex = Hex(rgb: rgb)
      let intValue = Int((value * 255).rounded())
      let expectedHexCode = String(format: "%02X%02X%02X", intValue, intValue, intValue)
      #expect(hex.code == expectedHexCode)
      #expect(rgb.rValue == value)
    }
  }

  @Test func testStaticColors() throws {
    #expect(Hex.black.code == "000000")
    #expect(Hex.white.code == "FFFFFF")
    #expect(Hex.red.code == "FF0000")
    #expect(Hex.green.code == "00FF00")
    #expect(Hex.blue.code == "0000FF")
    #expect(Hex.cyan.code == "00FFFF")
    #expect(Hex.magenta.code == "FF00FF")
    #expect(Hex.yellow.code == "FFFF00")
  }

  @Test func testDescription() throws {
    let hex = Hex("1A2B3C")
    #expect(hex.description == "#1A2B3C")

    #expect(Hex.black.description == "#000000")
    #expect(Hex.white.description == "#FFFFFF")
    #expect(Hex.red.description == "#FF0000")
    #expect(Hex.green.description == "#00FF00")
    #expect(Hex.blue.description == "#0000FF")
    #expect(Hex.cyan.description == "#00FFFF")
    #expect(Hex.magenta.description == "#FF00FF")
    #expect(Hex.yellow.description == "#FFFF00")
  }

  @Test func testToHSL() throws {
    var hsl = Hex.black.toHSL()
    #expect(hsl.hValue == 0.0 && hsl.sValue == 0.0 && hsl.lValue == 0.0)

    hsl = Hex.white.toHSL()
    #expect(hsl.hValue == 0.0 && hsl.sValue == 0.0 && hsl.lValue == 1.0)

    hsl = Hex.red.toHSL()
    #expect(hsl.hValue == 0.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)

    hsl = Hex.green.toHSL()
    #expect(hsl.hValue == 120.0 / 360.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)

    hsl = Hex.blue.toHSL()
    #expect(hsl.hValue == 240.0 / 360.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)

    hsl = Hex.cyan.toHSL()
    #expect(hsl.hValue == 180.0 / 360.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)

    hsl = Hex.magenta.toHSL()
    #expect(hsl.hValue == 300.0 / 360.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)

    hsl = Hex.yellow.toHSL()
    #expect(hsl.hValue == 60.0 / 360.0 && hsl.sValue == 1.0 && hsl.lValue == 0.5)
  }

}
